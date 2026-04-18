<template>
  <div class="users-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户列表</span>
          <el-input v-model="searchKey" placeholder="搜索用户名/邮箱" style="width: 200px;" clearable />
        </div>
      </template>
      <el-table :data="filteredUsers" v-loading="loading">
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="nickname" label="昵称" width="120" />
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="affectionLevel" label="好感度" width="100" sortable />
        <el-table-column prop="totalInteractionTime" label="互动时长(分钟)" width="140" sortable />
        <el-table-column prop="lastActive" label="最后活跃" width="180">
          <template #default="{ row }">
            {{ formatDate(row.lastActive) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'info'">
              {{ row.status === 'active' ? '活跃' : '沉默' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" @click="viewDetail(row)">详情</el-button>
            <el-button size="small" type="danger" @click="handleDisable(row)">禁用</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="total"
        layout="total, prev, pager, next"
        style="margin-top: 20px; justify-content: center;"
      />
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const searchKey = ref('')
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

const users = ref([])

onMounted(() => {
  loadUsers()
})

const loadUsers = () => {
  loading.value = true
  users.value = [
    { id: 1, username: 'user001', nickname: '小可爱', email: 'user001@example.com', affectionLevel: 520, totalInteractionTime: 3600, lastActive: new Date(), status: 'active' },
    { id: 2, username: 'user002', nickname: '孤独患者', email: 'user002@example.com', affectionLevel: 280, totalInteractionTime: 1800, lastActive: new Date(Date.now() - 86400000), status: 'active' },
    { id: 3, username: 'user003', nickname: '心灵旅者', email: 'user003@example.com', affectionLevel: 999, totalInteractionTime: 7200, lastActive: new Date(Date.now() - 172800000), status: 'active' }
  ]
  total.value = users.value.length
  loading.value = false
}

const filteredUsers = computed(() => {
  if (!searchKey.value) return users.value
  const key = searchKey.value.toLowerCase()
  return users.value.filter(u => 
    u.username.toLowerCase().includes(key) || 
    u.email.toLowerCase().includes(key) ||
    u.nickname.includes(key)
  )
})

const formatDate = (date) => {
  if (!date) return '-'
  const d = new Date(date)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
}

const viewDetail = (user) => {
  ElMessage.info(`查看用户 ${user.nickname} 的详细信息`)
}

const handleDisable = (user) => {
  ElMessage.success(`已禁用用户 ${user.nickname}`)
}
</script>

<style scoped lang="scss">
.users-page {
  padding: 20px;
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
}
</style>
