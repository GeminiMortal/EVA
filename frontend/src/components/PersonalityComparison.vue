<template>
  <div class="personality-comparison">
    <h3>人格对比分析</h3>
    <div class="comparison-controls">
      <select v-model="selectedPersonality1" @change="comparePersonalities">
        <option value="">选择第一个人格</option>
        <option 
          v-for="personality in personalities" 
          :key="personality.id"
          :value="personality.id"
        >
          {{ personality.name }}
        </option>
      </select>
      <select v-model="selectedPersonality2" @change="comparePersonalities">
        <option value="">选择第二个人格</option>
        <option 
          v-for="personality in personalities" 
          :key="personality.id"
          :value="personality.id"
        >
          {{ personality.name }}
        </option>
      </select>
    </div>
    
    <div v-if="comparisonResult" class="comparison-result">
      <div class="compatibility-score">
        <h4>兼容性评分: {{ Math.round(comparisonResult.compatibility_score * 100) }}%</h4>
        <div class="score-bar">
          <div 
            class="score-fill" 
            :style="{ width: comparisonResult.compatibility_score * 100 + '%' }"
            :class="getScoreClass(comparisonResult.compatibility_score)"
          ></div>
        </div>
      </div>
      
      <div class="trait-comparison">
        <h4>特征对比</h4>
        <div 
          v-for="(diff, trait) in comparisonResult.trait_differences" 
          :key="trait"
          class="trait-row"
        >
          <span class="trait-name">{{ trait }}</span>
          <div class="trait-values">
            <span class="value-1">{{ getTraitValue(personality1, trait) }}</span>
            <span class="vs">vs</span>
            <span class="value-2">{{ getTraitValue(personality2, trait) }}</span>
          </div>
          <div class="difference-indicator" :class="getDifferenceClass(diff)">
            {{ diff > 0 ? '↑' : diff < 0 ? '↓' : '=' }}
          </div>
        </div>
      </div>
      
      <div class="recommendations" v-if="comparisonResult.recommendations.length > 0">
        <h4>建议</h4>
        <ul>
          <li v-for="(rec, index) in comparisonResult.recommendations" :key="index">
            {{ rec }}
          </li>
        </ul>
      </div>
    </div>
    
    <div v-else class="no-comparison">
      请选择两个人格进行对比分析
    </div>
  </div>
</template>

<script>
import { api } from '../api/api';

export default {
  name: 'PersonalityComparison',
  props: {
    personalities: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      selectedPersonality1: '',
      selectedPersonality2: '',
      comparisonResult: null,
      personality1: null,
      personality2: null
    };
  },
  methods: {
    async comparePersonalities() {
      if (!this.selectedPersonality1 || !this.selectedPersonality2 || 
          this.selectedPersonality1 === this.selectedPersonality2) {
        this.comparisonResult = null;
        return;
      }

      try {
        // 获取两个人格的详细信息
        const [p1, p2] = await Promise.all([
          this.personalities.find(p => p.id === this.selectedPersonality1),
          this.personalities.find(p => p.id === this.selectedPersonality2)
        ]);
        
        this.personality1 = p1;
        this.personality2 = p2;

        // 调用后端对比API（如果存在）或本地计算
        // 这里我们先实现本地计算逻辑
        this.comparisonResult = this.calculateComparison(p1, p2);
      } catch (error) {
        console.error('对比分析失败:', error);
        this.$emit('error', '对比分析失败');
      }
    },
    
    calculateComparison(p1, p2) {
      const traits1 = p1.base_traits || {};
      const traits2 = p2.base_traits || {};
      
      // 计算兼容性评分
      let compatibilityScore = 0;
      let totalTraits = 0;
      const traitDifferences = {};
      const recommendations = [];
      
      // 收集所有特征键
      const allTraits = new Set([
        ...Object.keys(traits1), 
        ...Object.keys(traits2)
      ]);
      
      allTraits.forEach(trait => {
        const val1 = traits1[trait] || 0;
        const val2 = traits2[trait] || 0;
        const diff = val2 - val1;
        traitDifferences[trait] = diff;
        
        // 计算相似度（假设特征值在0-100范围内）
        const similarity = 1 - Math.abs(diff) / 100;
        compatibilityScore += Math.max(0, similarity);
        totalTraits++;
      });
      
      if (totalTraits > 0) {
        compatibilityScore /= totalTraits;
      }
      
      // 生成建议
      if (compatibilityScore < 0.3) {
        recommendations.push('这两个人格差异较大，可能不适合同时使用');
      } else if (compatibilityScore > 0.8) {
        recommendations.push('这两个人格非常相似，可以考虑合并');
      }
      
      Object.entries(traitDifferences).forEach(([trait, diff]) => {
        if (Math.abs(diff) > 50) {
          recommendations.push(`"${trait}"特征差异显著，需要注意切换时的一致性`);
        }
      });
      
      return {
        compatibility_score: compatibilityScore,
        trait_differences: traitDifferences,
        recommendations
      };
    },
    
    getTraitValue(personality, trait) {
      if (!personality || !personality.base_traits) return 'N/A';
      const value = personality.base_traits[trait];
      return typeof value === 'number' ? value.toFixed(1) : String(value);
    },
    
    getScoreClass(score) {
      if (score >= 0.8) return 'excellent';
      if (score >= 0.6) return 'good';
      if (score >= 0.4) return 'fair';
      return 'poor';
    },
    
    getDifferenceClass(diff) {
      if (diff > 10) return 'positive';
      if (diff < -10) return 'negative';
      return 'neutral';
    }
  },
  watch: {
    personalities: {
      handler() {
        // 重置选择
        this.selectedPersonality1 = '';
        this.selectedPersonality2 = '';
        this.comparisonResult = null;
      },
      deep: true
    }
  }
};
</script>

<style scoped>
.personality-comparison {
  background: #1a1a2e;
  border-radius: 12px;
  padding: 20px;
  margin-top: 20px;
}

.comparison-controls {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.comparison-controls select {
  flex: 1;
  padding: 10px;
  border: 2px solid #4a4a6a;
  border-radius: 8px;
  background: #0f0f1b;
  color: #e0e0ff;
  font-size: 14px;
}

.comparison-controls select:focus {
  outline: none;
  border-color: #6c5ce7;
}

.compatibility-score {
  margin-bottom: 20px;
}

.score-bar {
  height: 8px;
  background: #2d2d44;
  border-radius: 4px;
  overflow: hidden;
  margin-top: 8px;
}

.score-fill {
  height: 100%;
  transition: width 0.3s ease;
}

.score-fill.excellent { background: linear-gradient(90deg, #00b894, #00cec9); }
.score-fill.good { background: linear-gradient(90deg, #55efc4, #81ecec); }
.score-fill.fair { background: linear-gradient(90deg, #fdcb6e, #e17055); }
.score-fill.poor { background: linear-gradient(90deg, #ff7675, #d63031); }

.trait-comparison {
  margin-bottom: 20px;
}

.trait-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #2d2d44;
}

.trait-name {
  flex: 1;
  color: #a0a0c0;
  font-size: 14px;
}

.trait-values {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 2;
  justify-content: center;
}

.trait-values span {
  font-weight: 600;
  color: #e0e0ff;
}

.vs {
  color: #6c5ce7;
  font-weight: bold;
}

.difference-indicator {
  width: 30px;
  text-align: center;
  font-weight: bold;
  font-size: 16px;
}

.difference-indicator.positive { color: #00b894; }
.difference-indicator.negative { color: #ff7675; }
.difference-indicator.neutral { color: #fdcb6e; }

.recommendations ul {
  list-style: none;
  padding: 0;
}

.recommendations li {
  padding: 8px 0;
  color: #a0a0c0;
  border-bottom: 1px solid #2d2d44;
}

.no-comparison {
  text-align: center;
  color: #6c5ce7;
  padding: 40px 0;
  font-style: italic;
}
</style>