<template>
  <div class="orders-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>订单列表</span>
          <div class="header-actions">
            <el-select v-model="filterType" placeholder="订单类型" style="width: 120px; margin-right: 10px;" clearable>
              <el-option label="存入" value="deposit" />
              <el-option label="送礼" value="gift" />
              <el-option label="兑付" value="redeem" />
            </el-select>
            <el-select v-model="filterStatus" placeholder="订单状态" style="width: 120px; margin-right: 10px;" clearable>
              <el-option label="待处理" value="pending" />
              <el-option label="已完成" value="completed" />
              <el-option label="已取消" value="cancelled" />
            </el-select>
          </div>
        </div>
      </template>
      <el-table :data="filteredOrders" v-loading="loading">
        <el-table-column prop="orderId" label="订单号" width="180" />
        <el-table-column prop="userName" label="用户名" width="120" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getTypeTagType(row.type)">{{ getTypeLabel(row.type) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="amount" label="金额" width="120" sortable>
          <template #default="{ row }">
            <span style="color: #F56C6C; font-weight: bold;">¥{{ row.amount.toFixed(2) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusTagType(row.status)">{{ getStatusLabel(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="viewDetail(row)">详情</el-button>
            <el-button v-if="row.status === 'pending'" size="small" type="success" @click="handleProcess(row)">处理</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const filterType = ref('')
const filterStatus = ref('')

const orders = ref([])

onMounted(() => {
  loadOrders()
})

const loadOrders = () => {
  loading.value = true
  orders.value = [
    { orderId: 'ORD20240115001', userName: '用户001', type: 'deposit', amount: 100, status: 'completed', createdAt: '2024-01-15 10:30:00' },
    { orderId: 'ORD20240115002', userName: '用户002', type: 'gift', amount: 52, status: 'completed', createdAt: '2024-01-15 11:20:00' },
    { orderId: 'ORD20240115003', userName: '用户003', type: 'redeem', amount: 66.6, status: 'pending', createdAt: '2024-01-15 12:15:00' },
    { orderId: 'ORD20240115004', userName: '用户004', type: 'deposit', amount: 200, status: 'completed', createdAt: '2024-01-15 13:45:00' },
    { orderId: 'ORD20240115005', userName: '用户005', type: 'redeem', amount: 131.4, status: 'pending', createdAt: '2024-01-15 14:30:00' }
  ]
  loading.value = false
}

const filteredOrders = computed(() => {
  return orders.value.filter(o => {
    if (filterType.value && o.type !== filterType.value) return false
    if (filterStatus.value && o.status !== filterStatus.value) return false
    return true
  })
})

const getTypeLabel = (type) => {
  const map = { deposit: '存入', gift: '送礼', redeem: '兑付' }
  return map[type] || type
}

const getTypeTagType = (type) => {
  const map = { deposit: 'success', gift: 'warning', redeem: 'info' }
  return map[type] || ''
}

const getStatusLabel = (status) => {
  const map = { pending: '待处理', completed: '已完成', cancelled: '已取消' }
  return map[status] || status
}

const getStatusTagType = (status) => {
  const map = { pending: 'warning', completed: 'success', cancelled: 'info' }
  return map[status] || ''
}

const viewDetail = (order) => {
  ElMessage.info(`查看订单 ${order.orderId} 详情`)
}

const handleProcess = async (order) => {
  try {
    await ElMessageBox.confirm('确认处理此订单？', '提示', { type: 'warning' })
    ElMessage.success('订单已处理')
    loadOrders()
  } catch {
    // cancelled
  }
}
</script>

<style scoped lang="scss">
.orders-page {
  padding: 20px;
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .header-actions {
      display: flex;
    }
  }
}
</style>
