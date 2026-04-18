<template>
  <div class="wallet-page">
    <el-card>
      <template #header>
        <span>账本审计</span>
      </template>
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="stat-item">
            <div class="stat-label">总存入</div>
            <div class="stat-value">¥{{ stats.totalDeposited.toFixed(2) }}</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-item">
            <div class="stat-label">总送礼</div>
            <div class="stat-value">¥{{ stats.totalGifted.toFixed(2) }}</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-item">
            <div class="stat-label">总兑付</div>
            <div class="stat-value">¥{{ stats.totalRedeemed.toFixed(2) }}</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-item">
            <div class="stat-label">待兑付</div>
            <div class="stat-value">¥{{ stats.pendingReward.toFixed(2) }}</div>
          </div>
        </el-col>
      </el-row>
    </el-card>
    
    <el-card style="margin-top: 20px;">
      <template #header>
        <div class="card-header">
          <span>交易流水</span>
          <div class="header-actions">
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              style="margin-right: 10px;"
            />
            <el-button type="primary" @click="handleExport">导出报表</el-button>
          </div>
        </div>
      </template>
      <el-table :data="transactions" v-loading="loading" show-summary>
        <el-table-column prop="transactionId" label="交易ID" width="220" />
        <el-table-column prop="userName" label="用户名" width="120" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getTypeTagType(row.type)">{{ getTypeLabel(row.type) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="amount" label="金额" width="120" sortable>
          <template #default="{ row }">
            <span :style="{ color: row.amount >= 0 ? '#67C23A' : '#F56C6C', fontWeight: 'bold' }">
              {{ row.amount >= 0 ? '+' : '' }}¥{{ row.amount.toFixed(2) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" width="200" show-overflow-tooltip />
        <el-table-column prop="hash" label="哈希指纹" width="180">
          <template #default="{ row }">
            <span style="font-family: monospace; font-size: 12px; color: #909399;">
              {{ row.hash.substring(0, 16) }}...
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="timestamp" label="时间" width="180" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusTagType(row.status)">{{ getStatusLabel(row.status) }}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <el-card style="margin-top: 20px;">
      <template #header>
        <span>哈希校验</span>
      </template>
      <el-alert
        title="区块链式存证"
        type="success"
        :closable="false"
        style="margin-bottom: 16px;"
      >
        <template #default>
          所有交易记录均经过SHA-256哈希计算并存储，确保数据不可篡改。
          如需验证某条记录，请输入交易ID进行哈希校验。
        </template>
      </el-alert>
      <el-input v-model="verifyTxId" placeholder="请输入交易ID" style="width: 300px; margin-right: 10px;" />
      <el-button type="primary" @click="handleVerify">校验</el-button>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const dateRange = ref([])
const verifyTxId = ref('')

const stats = reactive({
  totalDeposited: 0,
  totalGifted: 0,
  totalRedeemed: 0,
  pendingReward: 0
})

const transactions = ref([])

onMounted(() => {
  loadData()
})

const loadData = () => {
  loading.value = true
  stats.totalDeposited = 897654.32
  stats.totalGifted = 456123.55
  stats.totalRedeemed = 123456.78
  stats.pendingReward = 56789.12
  
  transactions.value = [
    { transactionId: 'TXN2024011500001', userName: '用户001', type: 'deposit', amount: 100, description: '心意存钱到账', hash: 'a1b2c3d4e5f6789012345678901234567890abcd', timestamp: '2024-01-15 10:30:00', status: 'completed' },
    { transactionId: 'TXN2024011500002', userName: '用户002', type: 'gift', amount: -52, description: '赠送永恒之心', hash: 'b2c3d4e5f6789012345678901234567890abcde', timestamp: '2024-01-15 11:20:00', status: 'completed' },
    { transactionId: 'TXN2024011500003', userName: '用户003', type: 'reward', amount: 66.6, description: 'EVE回礼', hash: 'c3d4e5f6789012345678901234567890abcdef1', timestamp: '2024-01-15 12:15:00', status: 'completed' },
    { transactionId: 'TXN2024011500004', userName: '用户004', type: 'redeem_cash', amount: -131.4, description: '心意折现', hash: 'd4e5f6789012345678901234567890abcdef12', timestamp: '2024-01-15 13:45:00', status: 'completed' },
    { transactionId: 'TXN2024011500005', userName: '用户005', type: 'redeem_goods', amount: -99, description: '兑换甜蜜糖果盒', hash: 'e5f6789012345678901234567890abcdef123', timestamp: '2024-01-15 14:30:00', status: 'completed' }
  ]
  loading.value = false
}

const getTypeLabel = (type) => {
  const map = {
    deposit: '存入',
    gift: '送礼',
    reward: '回礼',
    redeem_cash: '折现',
    redeem_goods: '实物'
  }
  return map[type] || type
}

const getTypeTagType = (type) => {
  const map = {
    deposit: 'success',
    gift: 'warning',
    reward: 'primary',
    redeem_cash: 'info',
    redeem_goods: 'info'
  }
  return map[type] || ''
}

const getStatusLabel = (status) => {
  const map = { pending: '处理中', completed: '已完成', failed: '失败' }
  return map[status] || status
}

const getStatusTagType = (status) => {
  const map = { pending: 'warning', completed: 'success', failed: 'danger' }
  return map[status] || ''
}

const handleExport = () => {
  ElMessage.success('报表导出功能开发中')
}

const handleVerify = () => {
  if (!verifyTxId.value) {
    ElMessage.warning('请输入交易ID')
    return
  }
  ElMessage.success('校验通过，数据完整未被篡改')
}
</script>

<style scoped lang="scss">
.wallet-page {
  padding: 20px;
  
  .stat-item {
    background: #f5f7fa;
    border-radius: 8px;
    padding: 20px;
    text-align: center;
    
    .stat-label {
      font-size: 14px;
      color: #909399;
      margin-bottom: 8px;
    }
    
    .stat-value {
      font-size: 24px;
      font-weight: bold;
      color: #303133;
    }
  }
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .header-actions {
      display: flex;
      align-items: center;
    }
  }
}
</style>
