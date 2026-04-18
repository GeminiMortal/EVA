<template>
  <div class="gifts-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>礼物列表</span>
          <el-button type="primary" @click="showAddDialog">添加礼物</el-button>
        </div>
      </template>
      <el-table :data="gifts" v-loading="loading">
        <el-table-column prop="name" label="名称" width="150" />
        <el-table-column prop="description" label="描述" width="200" show-overflow-tooltip />
        <el-table-column prop="price" label="价格" width="100" sortable>
          <template #default="{ row }">
            ¥{{ row.price.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="category" label="分类" width="100">
          <template #default="{ row }">
            <el-tag>{{ getCategoryLabel(row.category) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="affectionBonus" label="好感加成" width="100" sortable />
        <el-table-column prop="stock" label="库存" width="100" sortable />
        <el-table-column prop="isActive" label="状态" width="100">
          <template #default="{ row }">
            <el-switch v-model="row.isActive" @change="handleStatusChange(row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form :model="giftForm" label-width="100px">
        <el-form-item label="名称">
          <el-input v-model="giftForm.name" placeholder="请输入礼物名称" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="giftForm.description" type="textarea" rows="3" placeholder="请输入礼物描述" />
        </el-form-item>
        <el-form-item label="价格">
          <el-input-number v-model="giftForm.price" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="giftForm.category" placeholder="请选择分类">
            <el-option label="心意信物" value="token" />
            <el-option label="专属礼盒" value="box" />
            <el-option label="亲密装扮" value="costume" />
            <el-option label="特别礼物" value="special" />
          </el-select>
        </el-form-item>
        <el-form-item label="好感加成">
          <el-input-number v-model="giftForm.affectionBonus" :min="0" />
        </el-form-item>
        <el-form-item label="库存">
          <el-input-number v-model="giftForm.stock" :min="-1" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('添加礼物')
const isEdit = ref(false)

const gifts = ref([])

const giftForm = reactive({
  id: null,
  name: '',
  description: '',
  price: 0,
  category: 'token',
  affectionBonus: 0,
  stock: -1,
  isActive: true
})

onMounted(() => {
  loadGifts()
})

const loadGifts = () => {
  loading.value = true
  gifts.value = [
    { id: 1, name: '永恒之心', description: '一颗代表永恒陪伴的心', price: 52, category: 'token', affectionBonus: 52, stock: -1, isActive: true },
    { id: 2, name: '甜蜜糖果盒', description: '装满甜蜜的糖果礼盒', price: 99, category: 'box', affectionBonus: 99, stock: -1, isActive: true },
    { id: 3, name: '温柔拥抱', description: '给你一个温暖的虚拟拥抱', price: 13.14, category: 'special', affectionBonus: 30, stock: -1, isActive: true },
    { id: 4, name: '星空物语', description: '陪你一起看星空', price: 131.4, category: 'token', affectionBonus: 131, stock: -1, isActive: true },
    { id: 5, name: '浪漫情书', description: 'EVE写给你的专属情书', price: 29.9, category: 'special', affectionBonus: 50, stock: -1, isActive: true },
    { id: 6, name: '甜蜜蛋糕', description: '为你定制的甜蜜蛋糕', price: 66.6, category: 'box', affectionBonus: 66, stock: -1, isActive: true }
  ]
  loading.value = false
}

const getCategoryLabel = (category) => {
  const map = { token: '心意信物', box: '专属礼盒', costume: '亲密装扮', special: '特别礼物' }
  return map[category] || category
}

const showAddDialog = () => {
  dialogTitle.value = '添加礼物'
  isEdit.value = false
  Object.assign(giftForm, { id: null, name: '', description: '', price: 0, category: 'token', affectionBonus: 0, stock: -1, isActive: true })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑礼物'
  isEdit.value = true
  Object.assign(giftForm, row)
  dialogVisible.value = true
}

const handleSave = () => {
  if (!giftForm.name || !giftForm.price) {
    ElMessage.warning('请填写必填项')
    return
  }
  ElMessage.success(isEdit.value ? '修改成功' : '添加成功')
  dialogVisible.value = false
  loadGifts()
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除此礼物？', '警告', { type: 'warning' })
    ElMessage.success('删除成功')
    loadGifts()
  } catch {
    // cancelled
  }
}

const handleStatusChange = (row) => {
  ElMessage.success(`礼物 ${row.name} 已${row.isActive ? '启用' : '禁用'}`)
}
</script>

<style scoped lang="scss">
.gifts-page {
  padding: 20px;
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
}
</style>
