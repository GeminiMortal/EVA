<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <div class="logo">
          <span class="logo-icon">🚀</span>
          <h1>EVA 管理系统</h1>
        </div>
        <p class="subtitle">欢迎回来，请登录您的账户</p>
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-item">
          <label for="username">用户名</label>
          <div class="input-wrapper">
            <span class="input-icon">👤</span>
            <input
              id="username"
              v-model="loginForm.username"
              type="text"
              placeholder="请输入用户名"
              :class="{ 'error': errors.username }"
              @blur="validateUsername"
            />
          </div>
          <span v-if="errors.username" class="error-message">{{ errors.username }}</span>
        </div>

        <div class="form-item">
          <label for="password">密码</label>
          <div class="input-wrapper">
            <span class="input-icon">🔒</span>
            <input
              id="password"
              v-model="loginForm.password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="请输入密码"
              :class="{ 'error': errors.password }"
              @blur="validatePassword"
            />
            <button
              type="button"
              class="toggle-password"
              @click="showPassword = !showPassword"
            >
              {{ showPassword ? '🙈' : '👁️' }}
            </button>
          </div>
          <span v-if="errors.password" class="error-message">{{ errors.password }}</span>
        </div>

        <div class="form-options">
          <label class="remember-me">
            <input type="checkbox" v-model="loginForm.remember" />
            <span>记住我</span>
          </label>
          <a href="#" class="forgot-password" @click.prevent="handleForgotPassword">忘记密码？</a>
        </div>

        <button type="submit" class="login-btn" :disabled="loading">
          <span v-if="loading" class="loading-spinner"></span>
          <span>{{ loading ? '登录中...' : '登 录' }}</span>
        </button>
      </form>

      <div class="login-footer">
        <p>© 2026 EVA Management System. All rights reserved.</p>
      </div>
    </div>

    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
  </div>
</template>

<script>
import { useRouter } from 'vue-router'
import authApi from '@/api/auth'
import auth from '@/utils/auth'

export default {
  name: 'LoginView',
  setup() {
    const router = useRouter()
    return { router }
  },
  data() {
    return {
      loginForm: {
        username: '',
        password: '',
        remember: false
      },
      errors: {
        username: '',
        password: ''
      },
      showPassword: false,
      loading: false
    }
  },
  mounted() {
    // 检查是否有记住的用户名
    const rememberedUsername = localStorage.getItem('rememberedUsername')
    if (rememberedUsername) {
      this.loginForm.username = rememberedUsername
      this.loginForm.remember = true
    }
  },
  methods: {
    validateUsername() {
      if (!this.loginForm.username.trim()) {
        this.errors.username = '请输入用户名'
        return false
      }
      if (this.loginForm.username.length < 3) {
        this.errors.username = '用户名至少3个字符'
        return false
      }
      this.errors.username = ''
      return true
    },
    validatePassword() {
      if (!this.loginForm.password) {
        this.errors.password = '请输入密码'
        return false
      }
      if (this.loginForm.password.length < 6) {
        this.errors.password = '密码至少6个字符'
        return false
      }
      this.errors.password = ''
      return true
    },
    async handleLogin() {
      // 验证表单
      const isUsernameValid = this.validateUsername()
      const isPasswordValid = this.validatePassword()

      if (!isUsernameValid || !isPasswordValid) {
        return
      }

      this.loading = true

      try {
        // 调用登录 API
        const result = await authApi.login({
          username: this.loginForm.username,
          password: this.loginForm.password
        })
        
        // 保存 token 和用户信息
        if (result.token) {
          auth.setToken(result.token)
        }
        if (result.user) {
          auth.setUserInfo(result.user)
        }
        
        // 如果选择记住我，保存用户名
        if (this.loginForm.remember) {
          localStorage.setItem('rememberedUsername', this.loginForm.username)
        } else {
          localStorage.removeItem('rememberedUsername')
        }

        // 跳转到首页
        this.router.push('/')
      } catch (error) {
        console.error('登录失败:', error)
        alert(error.message || '登录失败，请检查用户名和密码')
      } finally {
        this.loading = false
      }
    },
    handleForgotPassword() {
      alert('请联系管理员重置密码')
    }
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
  padding: 20px;
}

.login-box {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 40px;
  width: 100%;
  max-width: 420px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  position: relative;
  z-index: 1;
  animation: slideUp 0.5s ease-out;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.logo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-bottom: 10px;
}

.logo-icon {
  font-size: 40px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.logo h1 {
  margin: 0;
  font-size: 28px;
  color: #2c3e50;
  font-weight: 600;
}

.subtitle {
  margin: 0;
  color: #7f8c8d;
  font-size: 14px;
}

.login-form {
  margin-top: 30px;
}

.form-item {
  margin-bottom: 20px;
}

.form-item label {
  display: block;
  margin-bottom: 8px;
  color: #2c3e50;
  font-weight: 500;
  font-size: 14px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 12px;
  font-size: 18px;
  z-index: 1;
}

.input-wrapper input {
  width: 100%;
  padding: 12px 40px 12px 40px;
  border: 2px solid #e0e0e0;
  border-radius: 10px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: white;
}

.input-wrapper input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.input-wrapper input.error {
  border-color: #e74c3c;
}

.toggle-password {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 18px;
  padding: 0;
  transition: transform 0.2s;
}

.toggle-password:hover {
  transform: scale(1.1);
}

.error-message {
  display: block;
  color: #e74c3c;
  font-size: 12px;
  margin-top: 5px;
  animation: shake 0.3s;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  font-size: 14px;
}

.remember-me {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  color: #7f8c8d;
}

.remember-me input[type="checkbox"] {
  cursor: pointer;
  width: 16px;
  height: 16px;
}

.forgot-password {
  color: #667eea;
  text-decoration: none;
  transition: color 0.3s;
}

.forgot-password:hover {
  color: #764ba2;
  text-decoration: underline;
}

.login-btn {
  width: 100%;
  padding: 14px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
}

.login-btn:active:not(:disabled) {
  transform: translateY(0);
}

.login-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.loading-spinner {
  width: 20px;
  height: 20px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.login-footer {
  margin-top: 30px;
  text-align: center;
  color: #95a5a6;
  font-size: 12px;
}

.background-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
  overflow: hidden;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: pulse 4s ease-in-out infinite;
}

.circle-1 {
  width: 300px;
  height: 300px;
  top: -150px;
  right: -100px;
  animation-delay: 0s;
}

.circle-2 {
  width: 200px;
  height: 200px;
  bottom: -100px;
  left: -50px;
  animation-delay: 1s;
}

.circle-3 {
  width: 150px;
  height: 150px;
  top: 50%;
  left: 10%;
  animation-delay: 2s;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 0.1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.2;
  }
}

/* 响应式设计 */
@media (max-width: 480px) {
  .login-box {
    padding: 30px 20px;
  }

  .logo h1 {
    font-size: 24px;
  }

  .logo-icon {
    font-size: 32px;
  }
}
</style>
