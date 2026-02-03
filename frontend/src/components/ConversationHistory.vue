<template>
  <div class="conversation-history">
    <h3>对话历史</h3>
    <div class="history-filters">
      <select v-model="selectedPersonality" @change="loadConversations">
        <option value="">所有人格</option>
        <option 
          v-for="personality in personalities" 
          :key="personality.id" 
          :value="personality.id"
        >
          {{ personality.name }}
        </option>
      </select>
      <input 
        v-model="searchTerm" 
        placeholder="搜索对话..." 
        @input="debounceSearch"
      />
    </div>
    
    <div class="messages-container">
      <div 
        v-for="message in filteredMessages" 
        :key="message.id"
        class="message-item"
        :class="{ 'from-user': message.message_from === 'user', 'from-ai': message.message_from === 'ai' }"
      >
        <div class="message-header">
          <span class="sender">{{ message.message_from === 'user' ? '你' : personalityName(message.personality_id) }}</span>
          <span class="timestamp">{{ formatDate(message.created_at) }}</span>
          <span 
            v-if="message.sentiment_score !== null" 
            class="sentiment"
            :class="getSentimentClass(message.sentiment_score)"
          >
            {{ getSentimentLabel(message.sentiment_score) }}
          </span>
        </div>
        <div class="message-content">{{ message.content }}</div>
        <div v-if="message.context_data" class="context-data">
          <details>
            <summary>上下文数据</summary>
            <pre>{{ JSON.stringify(message.context_data, null, 2) }}</pre>
          </details>
        </div>
      </div>
    </div>
    
    <div class="pagination">
      <button 
        @click="loadPreviousPage" 
        :disabled="currentPage === 1"
      >
        上一页
      </button>
      <span>第 {{ currentPage }} 页</span>
      <button 
        @click="loadNextPage" 
        :disabled="!hasMorePages"
      >
        下一页
      </button>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { api } from '../api/api';

export default {
  name: 'ConversationHistory',
  props: {
    userId: {
      type: String,
      required: true
    }
  },
  emits: ['personality-selected'],
  setup(props, { emit }) {
    const conversations = ref([]);
    const personalities = ref([]);
    const selectedPersonality = ref('');
    const searchTerm = ref('');
    const currentPage = ref(1);
    const hasMorePages = ref(true);
    const limit = 20;
    
    const loadPersonalities = async () => {
      try {
        const response = await api.get(`/users/${props.userId}/personalities/`);
        personalities.value = response.data;
      } catch (error) {
        console.error('加载人格列表失败:', error);
      }
    };
    
    const loadConversations = async (page = 1) => {
      try {
        const offset = (page - 1) * limit;
        let url = `/users/${props.userId}/conversations/?limit=${limit}&offset=${offset}`;
        
        if (selectedPersonality.value) {
          url += `&personality_id=${selectedPersonality.value}`;
        }
        
        const response = await api.get(url);
        conversations.value = response.data;
        currentPage.value = page;
        hasMorePages.value = response.data.length === limit;
      } catch (error) {
        console.error('加载对话历史失败:', error);
      }
    };
    
    const personalityName = (personalityId) => {
      const personality = personalities.value.find(p => p.id === personalityId);
      return personality ? personality.name : '未知人格';
    };
    
    const formatDate = (dateString) => {
      const date = new Date(dateString);
      return date.toLocaleString('zh-CN');
    };
    
    const getSentimentClass = (score) => {
      if (score > 0.5) return 'positive';
      if (score < -0.5) return 'negative';
      return 'neutral';
    };
    
    const getSentimentLabel = (score) => {
      if (score > 0.5) return '😊';
      if (score < -0.5) return '😢';
      return '😐';
    };
    
    const filteredMessages = computed(() => {
      if (!searchTerm.value) return conversations.value;
      
      return conversations.value.filter(message => 
        message.content.toLowerCase().includes(searchTerm.value.toLowerCase())
      );
    });
    
    const debounceSearch = () => {
      // 简单的防抖实现
      clearTimeout(window.conversationSearchTimeout);
      window.conversationSearchTimeout = setTimeout(() => {
        loadConversations(currentPage.value);
      }, 300);
    };
    
    const loadPreviousPage = () => {
      if (currentPage.value > 1) {
        loadConversations(currentPage.value - 1);
      }
    };
    
    const loadNextPage = () => {
      loadConversations(currentPage.value + 1);
    };
    
    onMounted(async () => {
      await loadPersonalities();
      await loadConversations();
    });
    
    return {
      conversations,
      personalities,
      selectedPersonality,
      searchTerm,
      currentPage,
      hasMorePages,
      personalityName,
      formatDate,
      getSentimentClass,
      getSentimentLabel,
      filteredMessages,
      loadConversations,
      loadPreviousPage,
      loadNextPage,
      debounceSearch
    };
  }
};
</script>

<style scoped>
.conversation-history {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.history-filters {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  align-items: center;
}

.history-filters select,
.history-filters input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
}

.messages-container {
  max-height: 400px;
  overflow-y: auto;
  margin-bottom: 20px;
}

.message-item {
  padding: 12px;
  margin-bottom: 8px;
  border-radius: 8px;
  position: relative;
}

.from-user {
  background: #e3f2fd;
  margin-left: 20px;
}

.from-ai {
  background: #f5f5f5;
  margin-right: 20px;
}

.message-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  font-size: 12px;
  color: #666;
}

.sender {
  font-weight: bold;
}

.timestamp {
  font-style: italic;
}

.sentiment {
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 12px;
}

.sentiment.positive {
  background: #d4edda;
  color: #155724;
}

.sentiment.negative {
  background: #f8d7da;
  color: #721c24;
}

.sentiment.neutral {
  background: #fff3cd;
  color: #856404;
}

.message-content {
  font-size: 14px;
  line-height: 1.5;
}

.context-data {
  margin-top: 8px;
  font-size: 12px;
}

.context-data details summary {
  cursor: pointer;
  color: #007bff;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
}

.pagination button {
  padding: 6px 12px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
</component>