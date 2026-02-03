<template>
  <div class="personality-card" :class="{ active: personality.is_active, inactive: !personality.is_active }">
    <div class="card-header">
      <h3>{{ personality.name }}</h3>
      <div class="card-actions">
        <button 
          v-if="!personality.is_active" 
          @click="$emit('activate', personality.id)"
          class="btn btn-primary btn-sm"
        >
          激活
        </button>
        <button 
          v-if="personality.is_active" 
          class="btn btn-success btn-sm"
          disabled
        >
          已激活
        </button>
        <button 
          @click="$emit('edit', personality)"
          class="btn btn-secondary btn-sm"
        >
          编辑
        </button>
        <button 
          @click="$emit('delete', personality.id)"
          class="btn btn-danger btn-sm"
        >
          删除
        </button>
      </div>
    </div>
    
    <div class="card-body">
      <p class="description">{{ personality.description || '暂无描述' }}</p>
      
      <div class="stats">
        <div class="stat-item">
          <span class="stat-label">适应度</span>
          <span class="stat-value">{{ personality.adaptation_score.toFixed(2) }}</span>
        </div>
        <div class="stat-item">
          <span class=" stat-label">版本</span>
          <span class="stat-value">{{ personality.version }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">创建时间</span>
          <span class="stat-value">{{ formatDate(personality.created_at) }}</span>
        </div>
      </div>
      
      <div class="traits-preview">
        <h4>基础特征</h4>
        <div class="traits-grid">
          <div 
            v-for="(value, key) in personality.base_traits" 
            :key="key"
            class="trait-item"
          >
            <strong>{{ formatTraitName(key) }}:</strong> {{ value }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PersonalityCard',
  props: {
    personality: {
      type: Object,
      required: true
    }
  },
  emits: ['activate', 'edit', 'delete'],
  methods: {
    formatDate(date) {
      if (!date) return '未知';
      const d = new Date(date);
      return d.toLocaleDateString('zh-CN') + ' ' + d.toLocaleTimeString('zh-CN');
    },
    formatTraitName(name) {
      const traitNames = {
        'personality_type': '人格类型',
        'communication_style': '沟通风格',
        'emotional_range': '情感范围',
        'interests': '兴趣爱好',
        'values': '价值观',
        'humor_style': '幽默风格',
        'formality_level': '正式程度',
        'patience_level': '耐心程度',
        'curiosity_level': '好奇心',
        'empathy_level': '共情能力'
      };
      return traitNames[name] || name;
    }
  }
}
</script>

<style scoped>
.personality-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  margin: 10px 0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.personality-card.active {
  border-left: 4px solid #4CAF50;
  box-shadow: 0 4px 16px rgba(76, 175, 80, 0.2);
}

.personality-card.inactive:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.card-header h3 {
  margin: 0;
  color: #333;
  font-size: 1.2em;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.btn {
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.9em;
  transition: all 0.2s ease;
}

.btn-primary {
  background: #2196F3;
  color: white;
}

.btn-primary:hover {
  background: #1976D2;
}

.btn-success {
  background: #4CAF50;
  color: white;
}

.btn-secondary {
  background: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background: #5a6268;
}

.btn-danger {
  background: #f44336;
  color: white;
}

.btn-danger:hover {
  background: #d32f2f;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 0.8em;
}

.description {
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
}

.stats {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  padding: 10px;
  background: #f8f9fa;
  border-radius: 8px;
}

.stat-item {
  text-align: center;
}

.stat-label {
  display: block;
  font-size: 0.8em;
  color: #666;
  margin-bottom: 4px;
}

.stat-value {
  font-weight: bold;
  color: #333;
}

.traits-preview h4 {
  margin: 15px 0 10px 0;
  color: #333;
  font-size: 1em;
}

.traits-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 10px;
}

.trait-item {
  background: #e9ecef;
  padding: 8px;
  border-radius: 6px;
  font-size: 0.9em;
}

.trait-item strong {
  color: #495057;
}
</style>