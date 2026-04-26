<template>
  <div class="users">
    <h2>用户管理</h2>
    <div class="users-header">
      <div class="search-box">
        <input type="text" placeholder="搜索用户..." v-model="searchQuery">
        <button class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </div>
      <button class="add-btn">
        <i class="fas fa-plus"></i> 添加用户
      </button>
    </div>
    <div class="users-table-container">
      <table class="users-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>邮箱</th>
            <th>昵称</th>
            <th>好感度</th>
            <th>最后活跃</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.username }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.nickname }}</td>
            <td>{{ user.affectionLevel }}</td>
            <td>{{ formatDate(user.lastActive) }}</td>
            <td>
              <button class="action-btn view">
                <i class="fas fa-eye"></i>
              </button>
              <button class="action-btn edit">
                <i class="fas fa-edit"></i>
              </button>
              <button class="action-btn delete">
                <i class="fas fa-trash"></i>
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
  name: 'UsersView',
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      totalPages: 5,
      users: [
        {
          id: 1,
          username: 'user1',
          email: 'user1@example.com',
          nickname: '用户1',
          affectionLevel: 120,
          lastActive: new Date()
        },
        {
          id: 2,
          username: 'user2',
          email: 'user2@example.com',
          nickname: '用户2',
          affectionLevel: 85,
          lastActive: new Date(Date.now() - 86400000)
        },
        {
          id: 3,
          username: 'user3',
          email: 'user3@example.com',
          nickname: '用户3',
          affectionLevel: 200,
          lastActive: new Date(Date.now() - 172800000)
        }
      ]
    }
  },
  methods: {
    formatDate(date) {
      return new Date(date).toLocaleString();
    }
  }
}
</script>

<style scoped>
.users {
  padding: 20px;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.users-header {
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

.users-table-container {
  overflow-x: auto;
  margin-bottom: 20px;
}

.users-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.users-table th,
.users-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.users-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
}

.users-table tr:hover {
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
  .users-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .search-box {
    width: 100%;
  }
}
</style>
