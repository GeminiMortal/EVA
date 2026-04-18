<template>
  <div class="dashboard">
    <el-row :gutter="20">
      <el-col :span="6">
        <div class="stat-card stat-users">
          <div class="stat-icon">
            <el-icon><User /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.totalUsers }}</div>
            <div class="stat-label">总用户数</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-orders">
          <div class="stat-icon">
            <el-icon><Goods /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.totalOrders }}</div>
            <div class="stat-label">总订单数</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-amount">
          <div class="stat-icon">
            <el-icon><Money /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">¥{{ stats.totalAmount.toFixed(2) }}</div>
            <div class="stat-label">总交易金额</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-reward">
          <div class="stat-icon">
            <el-icon><Coin /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.totalRewards }}</div>
            <div class="stat-label">已兑付次数</div>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>30天交易趋势</span>
          </template>
          <div ref="chartRef" style="height: 300px;"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>用户活跃趋势</span>
          </template>
          <div ref="userChartRef" style="height: 300px;"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="24">
        <el-card>
          <template #header>
            <span>最新订单</span>
          </template>
          <el-table :data="recentOrders" style="width: 100%">
            <el-table-column prop="orderId" label="订单号" width="180" />
            <el-table-column prop="userName" label="用户名" width="120" />
            <el-table-column prop="type" label="类型" width="100">
              <template #default="{ row }">
                <el-tag v-if="row.type === 'deposit'" type="success">存入</el-tag>
                <el-tag v-else-if="row.type === 'gift'" type="warning">送礼</el-tag>
                <el-tag v-else type="info">兑付</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="amount" label="金额" width="100">
              <template #default="{ row }">
                ¥{{ row.amount.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag v-if="row.status === 'completed'" type="success">已完成</el-tag>
                <el-tag v-else-if="row.status === 'pending'" type="warning">处理中</el-tag>
                <el-tag v-else type="info">已取消</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createdAt" label="创建时间" />
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import * as echarts from 'echarts'

const chartRef = ref(null)
const userChartRef = ref(null)

const stats = reactive({
  totalUsers: 0,
  totalOrders: 0,
  totalAmount: 0,
  totalRewards: 0
})

const recentOrders = ref([])

onMounted(() => {
  stats.totalUsers = 1286
  stats.totalOrders = 3456
  stats.totalAmount = 897654.32
  stats.totalRewards = 156
  
  recentOrders.value = [
    { orderId: 'ORD20240101001', userName: '用户001', type: 'deposit', amount: 100, status: 'completed', createdAt: '2024-01-15 10:30:00' },
    { orderId: 'ORD20240101002', userName: '用户002', type: 'gift', amount: 52, status: 'completed', createdAt: '2024-01-15 11:20:00' },
    { orderId: 'ORD20240101003', userName: '用户003', type: 'redeem', amount: 66.6, status: 'pending', createdAt: '2024-01-15 12:15:00' },
    { orderId: 'ORD20240101004', userName: '用户004', type: 'deposit', amount: 200, status: 'completed', createdAt: '2024-01-15 13:45:00' },
    { orderId: 'ORD20240101005', userName: '用户005', type: 'gift', amount: 131.4, status: 'completed', createdAt: '2024-01-15 14:30:00' }
  ]
  
  initCharts()
})

const initCharts = () => {
  if (chartRef.value) {
    const chart = echarts.init(chartRef.value)
    chart.setOption({
      tooltip: { trigger: 'axis' },
      legend: { data: ['存入', '送礼', '兑付'] },
      xAxis: {
        type: 'category',
        data: ['1月10日', '1月11日', '1月12日', '1月13日', '1月14日', '1月15日']
      },
      yAxis: { type: 'value' },
      series: [
        { name: '存入', type: 'line', smooth: true, data: [12000, 15000, 18000, 14000, 20000, 22000] },
        { name: '送礼', type: 'line', smooth: true, data: [8000, 9500, 11000, 9000, 13000, 14000] },
        { name: '兑付', type: 'line', smooth: true, data: [3000, 4000, 3500, 5000, 4500, 6000] }
      ]
    })
  }
  
  if (userChartRef.value) {
    const chart = echarts.init(userChartRef.value)
    chart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: ['1月10日', '1月11日', '1月12日', '1月13日', '1月14日', '1月15日']
      },
      yAxis: { type: 'value' },
      series: [{
        name: '活跃用户',
        type: 'bar',
        data: [520, 580, 620, 550, 680, 720],
        itemStyle: { color: '#409EFF' }
      }]
    })
  }
}
</script>

<style scoped lang="scss">
.dashboard {
  padding: 20px;
  
  .stat-card {
    background: #fff;
    border-radius: 8px;
    padding: 20px;
    display: flex;
    align-items: center;
    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    
    .stat-icon {
      width: 60px;
      height: 60px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 16px;
      font-size: 28px;
      color: #fff;
    }
    
    .stat-info {
      .stat-value {
        font-size: 24px;
        font-weight: bold;
        color: #303133;
      }
      .stat-label {
        font-size: 14px;
        color: #909399;
        margin-top: 4px;
      }
    }
    
    &.stat-users .stat-icon { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    &.stat-orders .stat-icon { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
    &.stat-amount .stat-icon { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
    &.stat-reward .stat-icon { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
  }
}
</style>
