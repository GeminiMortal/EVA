import axios from 'axios'
import { ElMessage } from 'element-plus'

const request = axios.create({
  baseURL: '/api',
  timeout: 10000
})

request.interceptors.request.use(config => {
  const token = localStorage.getItem('admin_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  response => response.data,
  error => {
    const message = error.response?.data?.message || '请求失败'
    ElMessage.error(message)
    return Promise.reject(error)
  }
)

export default {
  login: (data) => request.post('/admin/login', data),
  getDashboardStats: () => request.get('/admin/stats'),
  getUsers: (params) => request.get('/admin/users', { params }),
  getOrders: (params) => request.get('/admin/orders', { params }),
  getGifts: () => request.get('/admin/gifts'),
  createGift: (data) => request.post('/admin/gifts', data),
  updateGift: (id, data) => request.put(`/admin/gifts/${id}`, data),
  deleteGift: (id) => request.delete(`/admin/gifts/${id}`),
  getWalletStats: () => request.get('/admin/wallet/stats'),
  getTransactions: (params) => request.get('/admin/wallet/transactions', { params }),
  verifyTransaction: (txId) => request.post('/admin/wallet/verify', { txId })
}
