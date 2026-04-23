<template>
  <div class="app-container">
    <AppSidebar @toggle="handleSidebarToggle" />
    <main class="main-content" :class="{ 'main-content-expanded': sidebarCollapsed }">
      <router-view/>
    </main>
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
  methods: {
    handleSidebarToggle(collapsed) {
      this.sidebarCollapsed = collapsed
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
</style>
