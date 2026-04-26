<template>
  <div class="dashboard">
    <h2>数据统计仪表盘</h2>
    <div class="dashboard-cards">
      <div class="card">
        <div class="card-header">
          <h3>总用户数</h3>
        </div>
        <div class="card-body">
          <div class="card-value">1,234</div>
          <div class="card-change positive">+12.5%</div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <h3>总交易金额</h3>
        </div>
        <div class="card-body">
          <div class="card-value">¥123,456</div>
          <div class="card-change positive">+8.2%</div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <h3>礼物赠送</h3>
        </div>
        <div class="card-body">
          <div class="card-value">567</div>
          <div class="card-change positive">+5.3%</div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <h3>待处理订单</h3>
        </div>
        <div class="card-body">
          <div class="card-value">12</div>
          <div class="card-change negative">-2.1%</div>
        </div>
      </div>
    </div>
    <div class="dashboard-charts">
      <div class="chart-container">
        <h3>用户增长趋势</h3>
        <div class="chart-placeholder">[用户增长图表]</div>
      </div>
      <div class="chart-container">
        <h3>交易金额分布</h3>
        <div class="chart-placeholder">[交易金额图表]</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DashboardView'
}
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.dashboard-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.card-header h3 {
  margin: 0;
  font-size: 14px;
  color: #666;
  font-weight: normal;
}

.card-body {
  margin-top: 15px;
}

.card-value {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.card-change {
  font-size: 12px;
  margin-top: 5px;
}

.card-change.positive {
  color: #4CAF50;
}

.card-change.negative {
  color: #F44336;
}

.dashboard-charts {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 20px;
}

.chart-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.chart-container h3 {
  margin: 0 0 15px 0;
  font-size: 16px;
  color: #333;
}

.chart-placeholder {
  height: 200px;
  background: #f5f5f5;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
}

@media (max-width: 768px) {
  .dashboard-charts {
    grid-template-columns: 1fr;
  }
}
</style>
