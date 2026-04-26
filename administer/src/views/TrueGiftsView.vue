<template>
  <div class="tgifts">
    <h2>现实礼物管理</h2>
    <div class="gifts-header">
      <div class="search-box">
        <input type="text" placeholder="搜索礼物..." v-model="searchQuery">
        <button class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </div>
      <button class="add-btn">
        <i class="fas fa-plus"></i> 添加礼物
      </button>
    </div>
    <div class="gifts-grid">
      <div class="gift-card" v-for="gift in gifts" :key="gift.id">
        <div class="gift-image">
          {{ gift.emoji }}
        </div>
        <div class="gift-info">
          <h3>{{ gift.name }}</h3>
          <p>{{ gift.description }}</p>
          <div class="gift-details">
            <span class="gift-price">¥{{ gift.price }}</span>
            <span class="gift-bonus">+{{ gift.affectionBonus }} 好感</span>
          </div>
          <div class="gift-actions">
            <button class="action-btn edit">
              <i class="fas fa-edit"></i> 编辑
            </button>
            <button class="action-btn delete">
              <i class="fas fa-trash"></i> 删除
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="pagination">
      <button class="page-btn" :disabled="currentPage === 1">上一页</button>
      <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
      <button class="page-btn" :disabled="currentPage === totalPages">下一页</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'GiftsView',
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      totalPages: 2,
      gifts: [
        {
          id: 1,
          name: '永恒之心',
          description: '一颗代表永恒陪伴的心',
          price: 52,
          emoji: '❤️',
          affectionBonus: 52
        },
        {
          id: 2,
          name: '甜蜜糖果盒',
          description: '装满甜蜜的糖果礼盒',
          price: 99,
          emoji: '🍬',
          affectionBonus: 99
        },
        {
          id: 3,
          name: '温柔拥抱',
          description: '给你一个温暖的虚拟拥抱',
          price: 13.14,
          emoji: '🤗',
          affectionBonus: 30
        },
        {
          id: 4,
          name: '星空物语',
          description: '陪你一起看星空',
          price: 131.4,
          emoji: '✨',
          affectionBonus: 131
        }
      ]
    }
  }
}
</script>

<style scoped>
.gifts {
  padding: 20px;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.gifts-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-box {
  display: flex;
  width: 300px;
}

.search-box input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px 0 0 4px;
  outline: none;
}

.search-btn {
  padding: 10px 15px;
  background: #4CAF50;
  color: white;
  border: none;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
}

.add-btn {
  padding: 10px 15px;
  background: #2196F3;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.gifts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.gift-card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  display: flex;
  gap: 15px;
}

.gift-image {
  font-size: 48px;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  border-radius: 8px;
}

.gift-info {
  flex: 1;
}

.gift-info h3 {
  margin: 0 0 8px 0;
  color: #333;
}

.gift-info p {
  margin: 0 0 12px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.4;
}

.gift-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.gift-price {
  font-size: 18px;
  font-weight: bold;
  color: #F44336;
}

.gift-bonus {
  padding: 4px 8px;
  background: #E3F2FD;
  color: #1565C0;
  border-radius: 12px;
  font-size: 12px;
}

.gift-actions {
  display: flex;
  gap: 10px;
}

.action-btn {
  flex: 1;
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  font-size: 14px;
}

.action-btn.edit {
  background: #FFC107;
  color: white;
}

.action-btn.delete {
  background: #F44336;
  color: white;
}

.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.page-btn {
  padding: 8px 12px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #666;
}

@media (max-width: 768px) {
  .gifts-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .search-box {
    width: 100%;
  }

  .gifts-grid {
    grid-template-columns: 1fr;
  }
}
</style>
