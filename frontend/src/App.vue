<template>
  <div id="app" class="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50">
    <header class="bg-white shadow-sm border-b">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <div class="w-10 h-10 bg-gradient-to-r from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
              <span class="text-white font-bold text-lg">GF</span>
            </div>
            <h1 class="text-2xl font-bold text-gray-900">Virtual GF Personality Studio</h1>
          </div>
          <div class="flex items-center space-x-4">
            <select v-model="currentUserId" @change="loadUserData" class="border rounded-lg px-3 py-2">
              <option value="">选择用户</option>
              <option v-for="user in users" :key="user.id" :value="user.id">{{ user.username }}</option>
            </select>
            <button @click="showUserModal = true" class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition">
              + 新用户
            </button>
          </div>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div v-if="!currentUserId" class="text-center py-20">
        <div class="text-6xl mb-4">🥥</div>
        <h2 class="text-3xl font-bold text-gray-900 mb-4">欢迎使用 Virtual GF Personality Studio</h2>
        <p class="text-gray-600 text-lg">请选择一个用户或创建新用户开始配置人格设定</p>
      </div>

      <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- 左侧：人格卡片列表 -->
        <div class="lg:col-span-1">
          <div class="bg-white rounded-xl shadow-sm p-6">
            <div class="flex items-center justify-between mb-6">
              <h2 class="text-xl font-bold text-gray-900">人格卡片</h2>
              <button @click="showPersonalityModal = true" class="bg-purple-600 text-white px-3 py-2 rounded-lg hover:bg-purple-700 transition text-sm">
                + 新建
              </button>
            </div>
            
            <div class="space-y-4">
              <div 
                v-for="personality in personalities" 
                :key="personality.id"
                @click="selectPersonality(personality)"
                :class="[
                  'p-4 rounded-lg cursor-pointer transition-all',
                  selectedPersonality?.id === personality.id 
                    ? 'ring-2 ring-purple-500 bg-purple-50' 
                    : 'hover:bg-gray-50'
                ]"
              >
                <div class="flex items-center justify-between mb-2">
                  <h3 class="font-semibold text-gray-900">{{ personality.name }}</h3>
                  <div v-if="personality.is_active" class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">
                    活跃
                  </div>
                </div>
                <p class="text-gray-600 text-sm mb-2">{{ personality.description || '无描述' }}</p>
                <div class="flex items-center justify-between text-xs text-gray-500">
                  <span>版本 {{ personality.version }}</span>
                  <span>适应度 {{ personality.adaptation_score.toFixed(2) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 右侧：人格详情和编辑 -->
        <div class="lg:col-span-2">
          <div v-if="selectedPersonality" class="bg-white rounded-xl shadow-sm p-6">
            <div class="flex items-center justify-between mb-6">
              <h2 class="text-xl font-bold text-gray-900">人格详情</h2>
              <div class="flex space-x-2">
                <button 
                  @click="activatePersonality(selectedPersonality.id)"
                  :disabled="selectedPersonality.is_active"
                  :class="[
                    'px-4 py-2 rounded-lg text-sm font-medium transition',
                    selectedPersonality.is_active 
                      ? 'bg-gray-100 text-gray-500 cursor-not-allowed' 
                      : 'bg-green-600 text-white hover:bg-green-700'
                  ]"
                >
                  设为活跃
                </button>
                <button 
                  @click="showPersonalityModal = true; editingPersonality = selectedPersonality"
                  class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition text-sm"
                >
                  编辑
                </button>
              </div>
            </div>

            <!-- 基础信息 -->
            <div class="mb-6">
              <h3 class="font-semibold text-gray-900 mb-3">基础信息</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600">姓名</label>
                  <p class="font-medium">{{ selectedPersonality.name }}</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">描述</label>
                  <p class="font-medium">{{ selectedPersonality.description || '无' }}</p>
                </div>
              </div>
            </div>

            <!-- 核心特征 -->
            <div class="mb-6">
              <h3 class="font-semibold text-gray-900 mb-3">核心特征</h3>
              <div class="grid grid-cols-2 gap-4">
                <div v-for="(value, key) in selectedPersonality.base_traits" :key="key">
                  <label class="text-sm text-gray-600 capitalize">{{ key.replace(/_/g, ' ') }}</label>
                  <p class="font-medium">{{ typeof value === 'object' ? JSON.stringify(value, null, 2) : value }}</p>
                </div>
              </div>
            </div>

            <!-- 学习模式 -->
            <div class="mb-6">
              <h3 class="font-semibold text-gray-900 mb-3">学习模式</h3>
              <div class="grid grid-cols-2 gap-4">
                <div v-for="(value, key) in selectedPersonality.learned_patterns" :key="key">
                  <label class="text-sm text-gray-600 capitalize">{{ key.replace(/_/g, ' ') }}</label>
                  <p class="font-medium">{{ typeof value === 'object' ? JSON.stringify(value, null, 2) : value }}</p>
                </div>
              </div>
            </div>

            <!-- 对话记忆 -->
            <div>
              <h3 class="font-semibold text-gray-900 mb-3">对话记忆 (最近5条)</h3>
              <div class="space-y-2 max-h-64 overflow-y-auto">
                <div v-for="(memory, index) in selectedPersonality.conversation_memory.slice(-5).reverse()" :key="index" class="p-3 bg-gray-50 rounded-lg">
                  <div class="text-sm text-gray-600 mb-1">话题: {{ memory.topic }}</div>
                  <div class="text-sm">关键点: {{ memory.key_points.join(', ') }}</div>
                  <div class="text-xs text-gray-500 mt-1">重要性: {{ memory.importance }} | 情感: {{ memory.emotional_tone }}</div>
                </div>
              </div>
            </div>
          </div>

          <div v-else class="bg-white rounded-xl shadow-sm p-12 text-center">
            <div class="text-4xl mb-4">✨</div>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">选择一个人格卡片</h3>
            <p class="text-gray-600">从左侧列表中选择一个人格卡片查看详情和进行编辑</p>
          </div>
        </div>
      </div>
    </main>

    <!-- 用户模态框 -->
    <Teleport to="body">
      <div v-if="showUserModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl p-6 w-full max-w-md">
          <h3 class="text-lg font-bold mb-4">创建新用户</h3>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">用户名</label>
              <input v-model="newUser.username" type="text" class="w-full border rounded-lg px-3 py-2" placeholder="输入用户名">
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">邮箱 (可选)</label>
              <input v-model="newUser.email" type="email" class="w-full border rounded-lg px-3 py-2" placeholder="输入邮箱">
            </div>
          </div>
          <div class="flex justify-end space-x-3 mt-6">
            <button @click="showUserModal = false" class="px-4 py-2 border rounded-lg">取消</button>
            <button @click="createUser" class="px-4 py-2 bg-purple-600 text-white rounded-lg">创建</button>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- 人格模态框 -->
    <Teleport to="body">
      <div v-if="showPersonalityModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
          <h3 class="text-lg font-bold mb-4">
            {{ editingPersonality ? '编辑人格' : '创建新人格' }}
          </h3>
          
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">人格名称 *</label>
              <input v-model="personalityForm.name" type="text" class="w-full border rounded-lg px-3 py-2" placeholder="例如: 温柔体贴型">
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">描述</label>
              <textarea v-model="personalityForm.description" class="w-full border rounded-lg px-3 py-2" rows="3" placeholder="这个人格的特点和适用场景"></textarea>
            </div>

            <!-- 核心特征表单 -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">核心特征</label>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-xs text-gray-600">性格类型</label>
                  <select v-model="personalityForm.base_traits.personality_type" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <option value="温柔体贴">温柔体贴</option>
                    <option value="活泼开朗">活泼开朗</option>
                    <option value="成熟稳重">成熟稳重</option>
                    <option value="俏皮可爱">俏皮可爱</option>
                    <option value="知性优雅">知性优雅</option>
                  </select>
                </div>
                
                <div>
                  <label class="text-xs text-gray-600">沟通风格</label>
                  <select v-model="personalityForm.base_traits.communication_style" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <option value="直接坦率">直接坦率</option>
                    <option value="委婉含蓄">委婉含蓄</option>
                    <option value="幽默风趣">幽默风趣</option>
                    <option value="温柔细腻">温柔细腻</option>
                  </select>
                </div>

                <div>
                  <label class="text-xs text-gray-600">情感表达</label>
                  <select v-model="personalityForm.base_traits.emotional_expression" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <option value="热情外放">热情外放</option>
                    <option value="内敛含蓄">内敛含蓄</option>
                    <option value="平衡适中">平衡适中</option>
                  </select>
                </div>

                <div>
                  <label class="text-xs text-gray-600">兴趣爱好</label>
                  <input v-model="personalityForm.base_traits.interests" type="text" class="w-full border rounded-lg px-3 py-2 text-sm" placeholder="用逗号分隔，如: 音乐,阅读,旅行">
                </div>
              </div>
            </div>

            <!-- 学习模式配置 -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">学习模式</label>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-xs text-gray-600">学习速度</label>
                  <select v-model="personalityForm.learned_patterns.learning_rate" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <option value="0.1">慢速</option>
                    <option value="0.3">中等</option>
                    <option value="0.5">快速</option>
                    <option value="0.8">极速</option>
                  </select>
                </div>
                
                <div>
                  <label class="text-xs text-gray-600">记忆持久度</label>
                  <select v-model="personalityForm.learned_patterns.memory_retention" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <option value="短期">短期</option>
                    <option value="中期">中期</option>
                    <option value="长期">长期</option>
                    <option value="永久">永久</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end space-x-3 mt-6">
            <button @click="closePersonalityModal" class="px-4 py-2 border rounded-lg">取消</button>
            <button @click="savePersonality" class="px-4 py-2 bg-purple-600 text-white rounded-lg">
              {{ editingPersonality ? '更新' : '创建' }}
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue'

export default {
  name: 'App',
  setup() {
    // 用户相关
    const users = ref([])
    const currentUserId = ref('')
    const showUserModal = ref(false)
    const newUser = ref({ username: '', email: '' })

    // 人格相关
    const personalities = ref([])
    const selectedPersonality = ref(null)
    const showPersonalityModal = ref(false)
    const editingPersonality = ref(null)
    
    const personalityForm = ref({
      name: '',
      description: '',
      base_traits: {
        personality_type: '温柔体贴',
        communication_style: '温柔细腻',
        emotional_expression: '平衡适中',
        interests: ''
      },
      learned_patterns: {
        learning_rate: '0.3',
        memory_retention: '中期'
      }
    })

    // API 基础URL
    const API_BASE = 'http://localhost:8000'

    // 加载用户列表
    const loadUsers = async () => {
      try {
        const response = await fetch(`${API_BASE}/users/`)
        if (response.ok) {
          // 注意：后端可能没有 GET /users/ 端点，需要调整
          const data = await response.json()
          users.value = Array.isArray(data) ? data : []
        }
      } catch (error) {
        console.error('加载用户失败:', error)
      }
    }

    // 创建用户
    const createUser = async () => {
      if (!newUser.value.username.trim()) return
      
      try {
        const response = await fetch(`${API_BASE}/users/`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            username: newUser.value.username,
            email: newUser.value.email || null
          })
        })
        
        if (response.ok) {
          const user = await response.json()
          users.value.push(user)
          currentUserId.value = user.id
          showUserModal.value = false
          newUser.value = { username: '', email: '' }
          loadUserData()
        }
      } catch (error) {
        console.error('创建用户失败:', error)
      }
    }

    // 加载用户数据（包括人格）
    const loadUserData = async () => {
      if (!currentUserId.value) return
      
      try {
        // 加载人格列表
        const personalitiesResponse = await fetch(`${API_BASE}/users/${currentUserId.value}/personalities/`)
        if (personalitiesResponse.ok) {
          personalities.value = await personalitiesResponse.json()
          selectedPersonality.value = null
        }
      } catch (error) {
        console.error('加载用户数据失败:', error)
      }
    }

    // 选择人格
    const selectPersonality = (personality) => {
      selectedPersonality.value = personality
    }

    // 设为活跃人格
    const activatePersonality = async (personalityId) => {
      try {
        const response = await fetch(`${API_BASE}/users/${currentUserId.value}/personalities/${personalityId}/activate`, {
          method: 'PUT'
        })
        
        if (response.ok) {
          // 更新本地状态
          personalities.value = personalities.value.map(p => ({
            ...p,
            is_active: p.id === personalityId
          }))
          if (selectedPersonality.value) {
            selectedPersonality.value.is_active = selectedPersonality.value.id === personalityId
          }
        }
      } catch (error) {
        console.error('激活人格失败:', error)
      }
    }

    // 打开人格模态框
    const openPersonalityModal = (personality = null) => {
      if (personality) {
        editingPersonality.value = personality
        personalityForm.value = {
          name: personality.name,
          description: personality.description || '',
          base_traits: { ...personality.base_traits },
          learned_patterns: { ...personality.learned_patterns }
        }
      } else {
        editingPersonality.value = null
        personalityForm.value = {
          name: '',
          description: '',
          base_traits: {
            personality_type: '温柔体贴',
            communication_style: '温柔细腻',
            emotional_expression: '平衡适中',
            interests: ''
          },
          learned_patterns: {
            learning_rate: '0.3',
            memory_retention: '中期'
          }
        }
      }
      showPersonalityModal.value = true
    }

    // 关闭人格模态框
    const closePersonalityModal = () => {
      showPersonalityModal.value = false
      editingPersonality.value = null
    }

    // 保存人格
    const savePersonality = async () => {
      if (!personalityForm.value.name.trim()) return
      
      try {
        if (editingPersonality.value) {
          // 更新现有人格 - 需要后端支持 PUT 方法
          console.log('更新人格:', editingPersonality.value.id)
          // 这里需要后端实现更新接口
        } else {
          // 创建新人格
          const response = await fetch(`${API_BASE}/users/${currentUserId.value}/personalities/`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(personalityForm.value)
          })
          
          if (response.ok) {
            const newPersonality = await response.json()
            personalities.value.push(newPersonality)
          }
        }
        
        closePersonalityModal()
        loadUserData()
      } catch (error) {
        console.error('保存人格失败:', error)
      }
    }

    // 初始化
    onMounted(() => {
      loadUsers()
    })

    // 监听当前用户变化
    watch(currentUserId, (newId) => {
      if (newId) {
        loadUserData()
      }
    })

    return {
      users,
      currentUserId,
      showUserModal,
      newUser,
      personalities,
      selectedPersonality,
      showPersonalityModal,
      editingPersonality,
      personalityForm,
      loadUsers,
      createUser,
      loadUserData,
      selectPersonality,
      activatePersonality,
      showPersonalityModal: showPersonalityModal,
      closePersonalityModal,
      savePersonality
    }
  }
}
</script>

<style scoped>
/* 添加一些自定义样式 */
#app {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}
</style>
</template>