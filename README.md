# Virtual GF Personality System

A FastAPI-based backend for a virtual girlfriend personality system with dynamic learning capabilities and multiple personality cards.

## 🚀 Features

- **User Management**: Create and manage user profiles
- **Personality Cards**: Multiple personality configurations per user
- **Dynamic Learning**: Store and adapt based on conversation history
- **Conversation History**: Full message tracking with sentiment analysis
- **Database Schema**: Optimized PostgreSQL schema with JSONB support
- **Docker Ready**: Complete Docker Compose setup for easy deployment

## 📦 Project Structure

```
.
├── .env                     # Environment variables
├── docker-compose.yml       # Multi-service orchestration
├── Dockerfile.api           # FastAPI application container
├── requirements.txt         # Python dependencies
├── app/
│   ├── __init__.py
│   └── main.py             # FastAPI application with all endpoints
└── database/
    └── init.sql            # Database initialization script
```

## 🛠️ Setup

### Prerequisites
- Docker and Docker Compose
- Python 3.11+ (for local development)

### Quick Start
1. Clone the repository
2. Set your database password in `.env`:
   ```bash
   DB_PASSWORD=your_secure_password_here
   ```
3. Start the services:
   ```bash
   docker-compose up -d
   ```
4. API will be available at `http://localhost:8000`

### API Endpoints

#### Users
- `POST /users/` - Create new user
- `GET /users/{user_id}` - Get user details

#### Personality Cards
- `POST /users/{user_id}/personalities/` - Create personality card
- `GET /users/{user_id}/personalities/` - List all personalities
- `GET /users/{user_id}/personalities/active` - Get active personality
- `PUT /users/{user_id}/personalities/{personality_id}/activate` - Activate personality

#### Conversations
- `POST /users/{user_id}/conversations/` - Add conversation message
- `GET /users/{user_id}/conversations/` - Get conversation history

## 🐳 Docker Compose Services

- **db**: PostgreSQL 15 database with custom initialization
- **api**: FastAPI application with asyncpg database connection
- **redis**: Optional Redis cache for session management

## 📝 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_PASSWORD` | `secure_password_123` | Database password |
| `DATABASE_URL` | `postgresql://admin:secure_password_123@db:5432/virtual_gf` | Database connection URL |

## 🔒 Security

- Uses PostgreSQL SCRAM-SHA-256 authentication
- Non-root user in Docker containers
- Environment variables for sensitive data

## 📈 Database Schema

The system uses three main tables:

1. **users**: User profiles with unique usernames
2. **personality_cards**: Personality configurations with JSONB traits
3. **conversation_history**: Message logs with sentiment scores and context

## 🤖 Future Enhancements

- [ ] WebSocket support for real-time conversations
- [ ] Machine learning integration for personality adaptation
- [ ] User authentication and authorization
- [ ] API documentation with Swagger/OpenAPI
- [ ] Testing suite with pytest

## 📄 License

MIT License