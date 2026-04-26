<template>
  <div class="orders">
    <h2>订单管理</h2>
    <div class="orders-header">
      <div class="search-box">
        <input type="text" placeholder="搜索订单..." v-model="searchQuery">
        <button class="search-btn">
          <i class="fas fa-search"></i>
        </button>
      </div>
      <div class="filter-box">
        <select v-model="statusFilter">
          <option value="all">全部状态</option>
          <option value="pending">待处理</option>
          <option value="processing">处理中</option>
          <option value="completed">已完成</option>
          <option value="cancelled">已取消</option>
        </select>
      </div>
    </div>
    <div class="orders-table-container">
      <table class="orders-table">
        <thead>
          <tr>
            <th>订单号</th>
            <th>用户ID</th>
            <th>类型</th>
            <th>金额</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.id">
            <td>{{ order.orderId }}</td>
            <td>{{ order.userId }}</td>
            <td>{{ order.type }}</td>
            <td>¥{{ order.amount }}</td>
            <td>
              <span :class="['status-badge', order.status]">
                {{ order.statusText }}
              </span>
            </td>
            <td>{{ formatDate(order.createdAt) }}</td>
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
  name: 'OrdersView',
  data() {
    return {
      searchQuery: '',
      statusFilter: 'all',
      currentPage: 1,
      totalPages: 3,
      orders: [
        {
          id: 1,
          orderId: 'ORD20260423001',
          userId: 1,
          type: 'deposit',
          amount: 100,
          status: 'completed',
          statusText: '已完成',
          createdAt: new Date()
        },
        {
          id: 2,
          orderId: 'ORD20260423002',
          userId: 2,
          type: 'gift',
          amount: 52,
          status: 'completed',
          statusText: '已完成',
          createdAt: new Date(Date.now() - 86400000)
        },
        {
          id: 3,
          orderId: 'ORD20260423003',
          userId: 3,
          type: 'redeem_cash',
          amount: 80,
          status: 'processing',
          statusText: '处理中',
          createdAt: new Date(Date.now() - 172800000)
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
.orders {
  padding: 20px;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.orders-header {
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

.filter-box select {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  outline: none;
}

.orders-table-container {
  overflow-x: auto;
  margin-bottom: 20px;
}

.orders-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.orders-table th,
.orders-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.orders-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
}

.orders-table tr:hover {
  background: #f9f9f9;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.pending {
  background: #FFF3CD;
  color: #856404;
}

.status-badge.processing {
  background: #E3F2FD;
  color: #1565C0;
}

.status-badge.completed {
  background: #D4EDDA;
  color: #155724;
}

.status-badge.cancelled {
  background: #F8D7DA;
  color: #721C24;
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
  .orders-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .search-box {
    width: 100%;
  }
}
</style>
