<template>
  <div class="personality-form">
    <h3>{{ editing ? '编辑人格' : '创建新人格' }}</h3>
    
    <form @submit.prevent="handleSubmit">
      <!-- 基础信息 -->
      <div class="form-section">
        <h4>基础信息</h4>
        <div class="form-group">
          <label for="name">人格名称 *</label>
          <input 
            id="name" 
            v-model="formData.name" 
            type="text" 
            required
            placeholder="例如：温柔姐姐、活泼妹妹、知性老师"
          />
        </div>
        
        <div class="form-group">
          <label for="description">描述</label>
          <textarea 
            id="description" 
            v-model="formData.description" 
            placeholder="这个人格的性格特点和背景故事..."
            rows="3"
          ></textarea>
        </div>
      </div>

      <!-- 核心特征 -->
      <div class="form-section">
        <h4>核心特征</h4>
        <div class="traits-grid">
          <div 
            v-for="(trait, key) in coreTraits" 
            :key="key"
            class="trait-item"
          >
            <label :for="`trait-${key}`">{{ trait.label }}</label>
            <input 
              :id="`trait-${key}`"
              v-model="formData.base_traits[key]"
              :type="trait.type || 'text'"
              :placeholder="trait.placeholder"
              :min="trait.min"
              :max="trait.max"
            />
          </div>
        </div>
      </div>

      <!-- 行为模式 -->
      <div class="form-section">
        <h4>行为模式</h4>
        <div class="form-group">
          <label for="speech_style">说话风格</label>
          <select v-model="formData.base_traits.speech_style">
            <option value="casual">随意自然</option>
            <option value="formal">正式礼貌</option>
            <option value="cute">可爱撒娇</option>
            <option value="cool">冷静酷炫</option>
            <option value="elegant">优雅知性</option>
          </select>
        </div>

        <div class="form-group">
          <label for="response_length">回复长度偏好</label>
          <select v-model="formData.base_traits.response_length">
            <option value="short">简短精炼</option>
            <option value="medium">适中详细</option>
            <option value="long">详细丰富</option>
          </select>
        </div>

        <div class="form-group">
          <label for="emoji_usage">表情符号使用</label>
          <select v-model="formData.base_traits.emoji_usage">
            <option value="none">从不使用</option>
            <option value="rare">偶尔使用</option>
            <option value="moderate">适度使用</option>
            <option value="frequent">频繁使用</option>
          </select>
        </div>
      </div>

      <!-- 兴趣爱好 -->
      <div class="form-section">
        <h4>兴趣爱好</h4>
        <div class="form-group">
          <label for="interests">兴趣标签（用逗号分隔）</label>
          <input 
            id="interests" 
            v-model="interestsInput"
            type="text" 
            placeholder="例如：音乐,电影,游戏,读书,旅行"
            @blur="updateInterests"
          />
          <div class="interest-tags" v-if="formData.base_traits.interests?.length">
            <span 
              v-for="interest in formData.base_traits.interests" 
              :key="interest"
              class="interest-tag"
            >
              {{ interest }}
              <button 
                type="button" 
                @click="removeInterest(interest)"
                class="remove-interest"
              >×</button>
            </span>
          </div>
        </div>
      </div>

      <!-- 高级设置 -->
      <div class="form-section advanced-section" v-if="showAdvanced">
        <h4>高级设置</h4>
        <div class="form-group">
          <label for="memory_retention">记忆保留度 (0-1)</label>
          <input 
            id="memory_retention" 
            v-model.number="formData.base_traits.memory_retention"
            type="number" 
            min="0" 
            max="1" 
            step="0.1"
          />
        </div>
        
        <div class="form-group">
          <label for="adaptation_speed">适应速度 (0-1)</label>
          <input 
            id="adaptation_speed" 
            v-model.number="formData.base_traits.adaptation_speed"
            type="number" 
            min="0" 
            max="1" 
            step="0.1"
          />
        </div>
      </div>

      <div class="form-actions">
        <button 
          type="button" 
          @click="toggleAdvanced"
          class="btn-secondary"
        >
          {{ showAdvanced ? '隐藏高级设置' : '显示高级设置' }}
        </button>
        <div class="primary-actions">
          <button 
            type="button" 
            @click="$emit('cancel')"
            class="btn-secondary"
          >
            取消
          </button>
          <button 
            type="submit" 
            class="btn-primary"
          >
            {{ editing ? '更新' : '创建' }}
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'PersonalityForm',
  props: {
    personality: {
      type: Object,
      default: () => ({
        name: '',
        description: '',
        base_traits: {}
      })
    },
    editing: {
      type: Boolean,
      default: false
    }
  },
  emits: ['submit', 'cancel'],
  data() {
    return {
      showAdvanced: false,
      interestsInput: '',
      formData: {
        name: '',
        description: '',
        base_traits: {
          age: 20,
          gender: 'female',
          speech_style: 'casual',
          response_length: 'medium',
          emoji_usage: 'moderate',
          interests: [],
          memory_retention: 0.7,
          adaptation_speed: 0.5
        }
      },
      coreTraits: {
        age: { label: '年龄', type: 'number', min: 16, max: 100 },
        gender: { label: '性别', type: 'select', options: ['female', 'male', 'other'] },
        warmth: { label: '温暖度 (0-10)', type: 'number', min: 0, max: 10 },
        playfulness: { label: '活泼度 (0-10)', type: 'number', min: 0, max: 10 },
        intelligence: { label: '智慧度 (0-10)', type: 'number', min: 0, max: 10 },
        confidence: { label: '自信度 (0-10)', type: 'number', min: 0, max: 10 }
      }
    }
  },
  watch: {
    personality: {
      handler(newVal) {
        if (newVal) {
          this.formData = {
            name: newVal.name || '',
            description: newVal.description || '',
            base_traits: { ...this.formData.base_traits, ...(newVal.base_traits || {}) }
          }
          this.interestsInput = (newVal.base_traits?.interests || []).join(', ')
        }
      },
      immediate: true
    }
  },
  methods: {
    toggleAdvanced() {
      this.showAdvanced = !this.showAdvanced
    },
    updateInterests() {
      if (this.interestsInput.trim()) {
        const interests = this.interestsInput
          .split(',')
          .map(i => i.trim())
          .filter(i => i.length > 0)
        this.$set(this.formData.base_traits, 'interests', interests)
      }
    },
    removeInterest(interestToRemove) {
      const interests = this.formData.base_traits.interests.filter(i => i !== interestToRemove)
      this.$set(this.formData.base_traits, 'interests', interests)
      this.interestsInput = interests.join(', ')
    },
    handleSubmit() {
      // 验证必填字段
      if (!this.formData.name.trim()) {
        alert('请填写人格名称')
        return
      }
      
      // 确保数值在范围内
      Object.keys(this.coreTraits).forEach(key => {
        if (this.coreTraits[key].type === 'number') {
          const value = this.formData.base_traits[key] || 0
          const min = this.coreTraits[key].min || 0
          const max = this.coreTraits[key].max || 10
          this.formData.base_traits[key] = Math.max(min, Math.min(max, value))
        }
      })
      
      this.$emit('submit', this.formData)
    }
  }
}
</script>

<style scoped>
.personality-form {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  max-width: 800px;
  margin: 0 auto;
}

.form-section {
  margin-bottom: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #eee;
}

.form-section:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.form-section h4 {
  margin-bottom: 16px;
  color: #333;
  font-size: 18px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #555;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 12px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 16px;
  transition: border-color 0.2s;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  outline: none;
  border-color: #4f46e5;
}

.traits-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.trait-item label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #555;
}

.interest-tags {
  margin-top: 8px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.interest-tag {
  background: #f0f2ff;
  color: #4f46e5;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 14px;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.remove-interest {
  background: none;
  border: none;
  color: #4f46e5;
  cursor: pointer;
  font-size: 16px;
  line-height: 1;
  padding: 0;
  margin-left: 4px;
}

.advanced-section {
  background: #f8fafc;
  padding: 24px;
  border-radius: 8px;
  margin-top: 24px;
}

.form-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 32px;
}

.primary-actions {
  display: flex;
  gap: 12px;
}

.btn-primary,
.btn-secondary {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: #4f46e5;
  color: white;
}

.btn-primary:hover {
  background: #4338ca;
}

.btn-secondary {
  background: #f1f5f9;
  color: #334155;
}

.btn-secondary:hover {
  background: #e2e8f0;
}

@media (max-width: 768px) {
  .personality-form {
    padding: 16px;
  }
  
  .form-actions {
    flex-direction: column;
    gap: 12px;
    align-items: stretch;
  }
  
  .primary-actions {
    justify-content: center;
  }
}
</style>
</component>