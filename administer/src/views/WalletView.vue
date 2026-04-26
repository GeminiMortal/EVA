<template>
  <div class="wallet">
    <h2>钱包管理</h2>
    <div class="wallet-header">
      <div class="search-box">
        <input type="text" placeholder="搜索用户..." v-model="searchQuery">
        <button class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>
    <div class="wallet-table-container">
      <table class="wallet-table">
        <thead>
          <tr>
            <th>用户ID</th>
            <th>用户名</th>
            <th>余额</th>
            <th>总存入</th>
            <th>总送礼</th>
            <th>总兑付</th>
            <th>待回礼</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="wallet in wallets" :key="wallet.id">
            <td>{{ wallet.userId }}</td>
            <td>{{ wallet.username }}</td>
            <td>¥{{ wallet.balance }}</td>
            <td>¥{{ wallet.totalDeposited }}</td>
            <td>¥{{ wallet.totalGifted }}</td>
            <td>¥{{ wallet.totalRedeemed }}</td>
            <td>¥{{ wallet.pendingReward }}</td>
            <td>
              <button class="action-btn view">
                <i class="fas fa-eye"></i>
              </button>
              <button class="action-btn edit">
                <i class="fas fa-edit"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
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
  name: 'WalletView',
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      totalPages: 3,
      wallets: [
        {
          id: 1,
          userId: 1,
          username: 'user1',
          balance: 500,
          totalDeposited: 1000,
          totalGifted: 300,
          totalRedeemed: 200,
          pendingReward: 50
        },
        {
          id: 2,
          userId: 2,
          username: 'user2',
          balance: 300,
          totalDeposited: 800,
          totalGifted: 400,
          totalRedeemed: 100,
          pendingReward: 30
        },
        {
          id: 3,
          userId: 3,
          username: 'user3',
          balance: 1000,
          totalDeposited: 2000,
          totalGifted: 800,
          totalRedeemed: 200,
          pendingReward: 100
        }
      ]
    }
  }
}
</script>

<style scoped>
.wallet {
  padding: 20px;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.wallet-header {
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

.wallet-table-container {
  overflow-x: auto;
  margin-bottom: 20px;
}

.wallet-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.wallet-table th,
.wallet-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.wallet-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
}

.wallet-table tr:hover {
  background: #f9f9f9;
}

.action-btn {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 5px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.action-btn.view {
  background: #2196F3;
  color: white;
}

.action-btn.edit {
  background: #FFC107;
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
  .search-box {
    width: 100%;
  }
}
</style>
