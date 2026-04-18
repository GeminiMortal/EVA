from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import uvicorn
import os
from dotenv import load_dotenv

from services.emotion_engine import EmotionEngine
from services.memory_engine import MemoryEngine
from services.personality_engine import PersonalityEngine
from services.response_generator import ResponseGenerator

load_dotenv()

app = FastAPI(title="EVE AI Core", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

emotion_engine = EmotionEngine()
memory_engine = MemoryEngine()
personality_engine = PersonalityEngine()
response_generator = ResponseGenerator()

class ChatMessage(BaseModel):
    user_id: str
    content: str
    session_id: Optional[str] = None

class MemoryItem(BaseModel):
    user_id: str
    memory_type: str
    content: str
    emotion: Optional[str] = "neutral"
    importance: Optional[int] = 5

class ChatResponse(BaseModel):
    content: str
    emotion: str
    confidence: float
    suggested_emojis: List[str]
    memory_triggered: Optional[Dict] = None

@app.on_event("startup")
async def startup_event():
    print("EVE AI Core 正在初始化...")
    emotion_engine.load_models()
    memory_engine.load_index()
    print("EVE AI Core 初始化完成！")

@app.get("/")
async def root():
    return {"message": "EVE AI Core Service", "version": "1.0.0"}

@app.post("/api/chat", response_model=ChatResponse)
async def chat(message: ChatMessage):
    try:
        emotion_result = emotion_engine.analyze_emotion(message.content)
        
        related_memories = memory_engine.retrieve_memories(
            message.user_id, 
            message.content
        )
        
        personality_filtered = personality_engine.apply_personality(
            emotion_result,
            related_memories
        )
        
        response = response_generator.generate(
            message.content,
            emotion_result,
            related_memories,
            personality_filtered
        )
        
        if response["should_save_memory"]:
            await memory_engine.save_memory({
                "user_id": message.user_id,
                "content": message.content,
                "emotion": emotion_result["primary_emotion"],
                "memory_type": emotion_result["memory_type"],
                "importance": emotion_result["importance"]
            })
        
        return ChatResponse(
            content=response["content"],
            emotion=response["emotion"],
            confidence=response["confidence"],
            suggested_emojis=response["emojis"],
            memory_triggered=related_memories[0] if related_memories else None
        )
        
    except Exception as e:
        print(f"聊天处理错误: {e}")
        raise HTTPException(status_code=500, detail="AI处理错误")

@app.post("/api/memory/save")
async def save_memory(memory: MemoryItem):
    try:
        result = await memory_engine.save_memory(memory.dict())
        return {"success": True, "memory_id": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/memory/{user_id}")
async def get_memories(user_id: str, memory_type: Optional[str] = None, limit: int = 20):
    try:
        memories = memory_engine.get_user_memories(user_id, memory_type, limit)
        return {"success": True, "memories": memories}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/emotion/analyze")
async def analyze_emotion_endpoint(content: str):
    try:
        result = emotion_engine.analyze_emotion(content)
        return {"success": True, "emotion": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "service": "EVE AI Core"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
