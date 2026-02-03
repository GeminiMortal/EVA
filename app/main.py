from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import asyncpg
import os
from contextlib import asynccontextmanager
from urllib.parse import urlparse

# Database connection pool
pool = None

def parse_database_url(database_url: str):
    """Parse DATABASE_URL and return connection parameters"""
    url = urlparse(database_url)
    return {
        'host': url.hostname,
        'port': url.port or 5432,
        'database': url.path[1:],  # Remove leading '/'
        'user': url.username,
        'password': url.password,
    }

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    global pool
    database_url = os.getenv('DATABASE_URL', 'postgresql://admin:secure_password_123@localhost:5432/virtual_gf')
    conn_params = parse_database_url(database_url)
    
    pool = await asyncpg.create_pool(
        host=conn_params['host'],
        port=conn_params['port'],
        database=conn_params['database'],
        user=conn_params['user'],
        password=conn_params['password']
    )
    yield
    # Shutdown
    await pool.close()

app = FastAPI(title="Virtual GF Personality System", lifespan=lifespan)

# Pydantic models
class UserCreate(BaseModel):
    username: str
    email: Optional[str] = None

class UserResponse(BaseModel):
    id: str
    username: str
    email: Optional[str] = None

class PersonalityCardCreate(BaseModel):
    name: str
    description: Optional[str] = None
    base_traits: Optional[Dict[str, Any]] = None

class PersonalityCardResponse(BaseModel):
    id: str
    user_id: str
    name: str
    description: Optional[str] = None
    base_traits: Optional[Dict[str, Any]] = None
    learned_patterns: Optional[Dict[str, Any]] = None
    adaptation_score: float
    is_active: bool
    version: int

class ConversationMessage(BaseModel):
    message_from: str
    content: str
    sentiment_score: Optional[float] = None
    context_data: Optional[Dict[str, Any]] = None

# Database dependency
async def get_db():
    async with pool.acquire() as conn:
        yield conn

@app.get("/")
async def root():
    return {"message": "Virtual GF Personality System API", "version": "1.0.0"}

@app.post("/users/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate, db=Depends(get_db)):
    try:
        query = """
        INSERT INTO users (username, email) 
        VALUES ($1, $2) 
        RETURNING id, username, email
        """
        result = await db.fetchrow(query, user.username, user.email)
        return dict(result)
    except asyncpg.UniqueViolationError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already exists"
        )

@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: str, db=Depends(get_db)):
    query = "SELECT id, username, email FROM users WHERE id = $1"
    result = await db.fetchrow(query, user_id)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return dict(result)

@app.post("/users/{user_id}/personalities/", response_model=PersonalityCardResponse, status_code=status.HTTP_201_CREATED)
async def create_personality_card(
    user_id: str, 
    personality: PersonalityCardCreate, 
    db=Depends(get_db)
):
    query = """
    INSERT INTO personality_cards (user_id, name, description, base_traits)
    VALUES ($1, $2, $3, $4)
    RETURNING id, user_id, name, description, base_traits, 
              learned_patterns, adaptation_score, is_active, version
    """
    result = await db.fetchrow(
        query, 
        user_id, 
        personality.name, 
        personality.description, 
        personality.base_traits or {}
    )
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return dict(result)

@app.get("/users/{user_id}/personalities/", response_model=List[PersonalityCardResponse])
async def get_user_personalities(user_id: str, db=Depends(get_db)):
    query = """
    SELECT id, user_id, name, description, base_traits, 
           learned_patterns, adaptation_score, is_active, version
    FROM personality_cards 
    WHERE user_id = $1
    """
    results = await db.fetch(query, user_id)
    return [dict(row) for row in results]

@app.get("/users/{user_id}/personalities/active", response_model=PersonalityCardResponse)
async def get_active_personality(user_id: str, db=Depends(get_db)):
    query = """
    SELECT id, user_id, name, description, base_traits, 
           learned_patterns, adaptation_score, is_active, version
    FROM personality_cards 
    WHERE user_id = $1 AND is_active = true
    """
    result = await db.fetchrow(query, user_id)
    if not result:
        raise HTTPException(status_code=404, detail="Active personality not found")
    return dict(result)

@app.put("/users/{user_id}/personalities/{personality_id}/activate")
async def activate_personality(user_id: str, personality_id: str, db=Depends(get_db)):
    # First deactivate all other personalities
    await db.execute(
        "UPDATE personality_cards SET is_active = false WHERE user_id = $1",
        user_id
    )
    # Then activate the specified one
    result = await db.execute(
        "UPDATE personality_cards SET is_active = true WHERE id = $1 AND user_id = $2",
        personality_id, user_id
    )
    if result == "UPDATE 0":
        raise HTTPException(status_code=404, detail="Personality not found")
    return {"message": "Personality activated successfully"}

@app.post("/users/{user_id}/conversations/", status_code=status.HTTP_201_CREATED)
async def add_conversation_message(
    user_id: str, 
    message: ConversationMessage, 
    personality_id: Optional[str] = None,
    db=Depends(get_db)
):
    query = """
    INSERT INTO conversation_history (user_id, personality_id, message_from, content, sentiment_score, context_data)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING id
    """
    result = await db.fetchrow(
        query, 
        user_id, 
        personality_id, 
        message.message_from, 
        message.content, 
        message.sentiment_score, 
        message.context_data or {}
    )
    return {"message_id": str(result["id"])}

@app.get("/users/{user_id}/conversations/", response_model=List[Dict[str, Any]])
async def get_conversation_history(user_id: str, limit: int = 50, db=Depends(get_db)):
    query = """
    SELECT id, user_id, personality_id, message_from, content, 
           sentiment_score, context_data, created_at
    FROM conversation_history 
    WHERE user_id = $1 
    ORDER BY created_at DESC 
    LIMIT $2
    """
    results = await db.fetch(query, user_id, limit)
    return [dict(row) for row in results]