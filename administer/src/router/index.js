import { createRouter, createWebHashHistory } from 'vue-router'
import auth from '@/utils/auth'

const routes = [
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    name: 'dashboard',
    component: () => import('@/views/DashboardView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/users',
    name: 'users',
    component: () => import('@/views/UsersView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/orders',
    name: 'orders',
    component: () => import('@/views/OrdersView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/gifts',
    name: 'gifts',
    component: () => import('@/views/GiftsView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/tgifts',
    name: 'tgifts',
    component: () => import('@/views/TrueGiftsView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/wallet',
    name: 'wallet',
    component: () => import('@/views/WalletView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// 路由守卫 - 检查登录状态
router.beforeEach((to, from, next) => {
  const isAuthenticated = auth.isAuthenticated()
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    // 需要登录但未登录，跳转到登录页
    next('/login')
  } else if (to.path === '/login' && isAuthenticated) {
    // 已登录但访问登录页，跳转到首页
    next('/')
  } else {
    next()
  }
})

export default router