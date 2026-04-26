import http from '@/utils/request'

/**
 * 认证相关 API
 */
export default {
  /**
   * 用户登录
   * @param {Object} credentials - 登录凭证
   * @param {string} credentials.username - 用户名
   * @param {string} credentials.password - 密码
   * @returns {Promise} 返回用户信息和 token
   */
  login(credentials) {
    return http.post('/auth/login', credentials)
  },

  /**
   * 用户登出
   * @returns {Promise}
   */
  logout() {
    return http.post('/auth/logout')
  },

  /**
   * 获取当前用户信息
   * @returns {Promise} 返回用户信息
   */
  getUserInfo() {
    return http.get('/auth/userinfo')
  },

  /**
   * 刷新 token
   * @returns {Promise} 返回新的 token
   */
  refreshToken() {
    return http.post('/auth/refresh')
  }
}
