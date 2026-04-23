<template>
  <aside class="sidebar" :class="{ 'sidebar-collapsed': collapsed }">
    <div class="sidebar-header">
      <h2 v-if="!collapsed">{{ title }}</h2>
      <button class="toggle-btn" @click="toggleSidebar">
        {{ collapsed ? '▶' : '◀' }}
      </button>
    </div>

    <nav class="sidebar-nav">
      <ul>
        <li v-for="item in menuItems" :key="item.path" class="nav-item">
          <router-link :to="item.path" class="nav-link">
            <span class="nav-icon">{{ item.icon }}</span>
            <span v-if="!collapsed" class="nav-text">{{ item.name }}</span>
          </router-link>
        </li>
      </ul>
    </nav>

    <div class="sidebar-footer" v-if="!collapsed">
      <p>{{ footerText }}</p>
    </div>
  </aside>
</template>

<script>
export default {
  name: 'AppSidebar',
  props: {
    title: {
      type: String,
      default: 'EVA 管理系统'
    },
    footerText: {
      type: String,
      default: '© 2026 EVA'
    },
    menuItems: {
      type: Array,
      default: () => [
        { name: '首页', path: '/', icon: '🏠' },
        { name: '用户管理', path: '/client', icon: '👥' },
        { name: '关于', path: '/about', icon: 'ℹ️' }
      ]
    }
  },
  data() {
    return {
      collapsed: false
    }
  },
  methods: {
    toggleSidebar() {
      this.collapsed = !this.collapsed
      this.$emit('toggle', this.collapsed)
    }
  }
}
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  background: linear-gradient(180deg, #2c3e50 0%, #1a252f 100%);
  color: #ecf0f1;
  position: fixed;
  left: 0;
  top: 0;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}

.sidebar-collapsed {
  width: 70px;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 70px;
}

.sidebar-header h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.toggle-btn {
  background: rgba(255, 255, 255, 0.1);
  border: none;
  color: #ecf0f1;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.toggle-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: scale(1.05);
}

.sidebar-nav {
  flex: 1;
  overflow-y: auto;
  padding: 15px 0;
}

.sidebar-nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.nav-item {
  margin: 5px 10px;
}

.nav-link {
  display: flex;
  align-items: center;
  padding: 12px 15px;
  color: #bdc3c7;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s ease;
  gap: 12px;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.1);
  color: #ecf0f1;
  transform: translateX(5px);
}

.nav-link.router-link-active {
  background: rgba(66, 185, 131, 0.2);
  color: #42b983;
  font-weight: 600;
}

.nav-icon {
  font-size: 20px;
  width: 24px;
  text-align: center;
  flex-shrink: 0;
}

.nav-text {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.sidebar-footer {
  padding: 15px 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  text-align: center;
  font-size: 12px;
  color: #95a5a6;
}

.sidebar-footer p {
  margin: 0;
}

/* 滚动条样式 */
.sidebar-nav::-webkit-scrollbar {
  width: 6px;
}

.sidebar-nav::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.sidebar-nav::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.sidebar-nav::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>