/**
 * Type definitions for the Virtual GF Personality System
 */

// User types
export class User {
  constructor(data = {}) {
    this.id = data.id || '';
    this.username = data.username || '';
    this.email = data.email || null;
    this.createdAt = data.created_at || new Date().toISOString();
  }
}

// Personality types
export class PersonalityCard {
  constructor(data = {}) {
    this.id = data.id || '';
    this.userId = data.user_id || '';
    this.name = data.name || '';
    this.description = data.description || '';
    this.baseTraits = data.base_traits || {};
    this.learnedPatterns = data.learned_patterns || {};
    this.conversationMemory = data.conversation_memory || [];
    this.adaptationScore = data.adaptation_score || 0.0;
    this.isActive = data.is_active || false;
    this.version = data.version || 1;
    this.createdAt = data.created_at || new Date().toISOString();
    this.updatedAt = data.updated_at || new Date().toISOString();
    
    // Enhanced fields
    this.category = data.category || 'general';
    this.moodRange = data.mood_range || { min: 0, max: 100 };
    this.compatibilityScore = data.compatibility_score || null;
    this.tags = data.tags || [];
    this.avatarUrl = data.avatar_url || null;
  }
}

// Conversation types
export class ConversationMessage {
  constructor(data = {}) {
    this.id = data.id || '';
    this.userId = data.user_id || '';
    this.personalityId = data.personality_id || null;
    this.messageFrom = data.message_from || 'user';
    this.content = data.content || '';
    this.sentimentScore = data.sentiment_score || null;
    this.contextData = data.context_data || {};
    this.createdAt = data.created_at || new Date().toISOString();
  }
}

// Form types
export class PersonalityForm {
  constructor() {
    this.name = '';
    this.description = '';
    this.category = 'general';
    this.baseTraits = {
      warmth: 50,
      playfulness: 50,
      intelligence: 50,
      empathy: 50,
      confidence: 50,
      creativity: 50
    };
    this.moodRange = { min: 30, max: 70 };
    this.tags = [];
    this.avatarUrl = '';
  }
}

// API response types
export class ApiResponse {
  constructor(success = true, data = null, message = '') {
    this.success = success;
    this.data = data;
    this.message = message;
  }
}