-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Personality cards table
CREATE TABLE personality_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    base_traits JSONB,
    learned_patterns JSONB,
    conversation_memory JSONB[],
    adaptation_score FLOAT DEFAULT 0.0,
    is_active BOOLEAN DEFAULT false,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Conversation history table
CREATE TABLE conversation_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    personality_id UUID REFERENCES personality_cards(id) ON DELETE CASCADE,
    message_from VARCHAR(20),
    content TEXT NOT NULL,
    sentiment_score FLOAT,
    context_data JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Personality switches table
CREATE TABLE personality_switches (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    from_personality_id UUID,
    to_personality_id UUID REFERENCES personality_cards(id),
    switch_reason VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_personality_user ON personality_cards(user_id);
CREATE INDEX idx_personality_active ON personality_cards(is_active);
CREATE INDEX idx_conversation_user ON conversation_history(user_id);
CREATE INDEX idx_conversation_personality ON conversation_history(personality_id);
CREATE INDEX idx_conversation_created ON conversation_history(created_at);