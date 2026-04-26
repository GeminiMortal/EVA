<template>
  <div class="app-container">
    <!-- 登录页面不需要侧边栏 -->
    <template v-if="!isLoginPage">
      <AppSidebar @toggle="handleSidebarToggle" />
      <main class="main-content" :class="{ 'main-content-expanded': sidebarCollapsed }">
        <router-view/>
      </main>
    </template>
    <!-- 登录页面直接显示 -->
    <template v-else>
      <router-view/>
    </template>
  </div>
</template>

<script>
import AppSidebar from '@/components/Sidebar.vue'

export default {
  name: 'App',
  components: {
    AppSidebar
  },
  data() {
    return {
      sidebarCollapsed: false
    }
  },
  computed: {
    isLoginPage() {
      return this.$route.path === '/login'
    }
  },
  methods: {
    handleSidebarToggle(collapsed) {
      this.sidebarCollapsed = collapsed
    }
  }
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  background: #f5f7fa;
}

.app-container {
  display: flex;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  margin-left: 250px;
  transition: margin-left 0.3s ease;
  padding: 20px;
  background: #f5f7fa;
}

.main-content-expanded {
  margin-left: 70px;
}

@media (max-width: 768px) {
  .main-content {
    margin-left: 70px;
  }
  
  .main-content-expanded {
    margin-left: 0;
  }
}
</style>
