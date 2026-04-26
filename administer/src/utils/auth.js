/**
 * 用户认证工具类
 */
export default {
  /**
   * 保存 token
   * @param {string} token - JWT token
   */
  setToken(token) {
    if (token) {
      localStorage.setItem('token', token)
    }
  },

  /**
   * 获取 token
   * @returns {string|null} token
   */
  getToken() {
    return localStorage.getItem('token')
  },

  /**
   * 移除 token
   */
  removeToken() {
    localStorage.removeItem('token')
  },

  /**
   * 检查是否已登录
   * @returns {boolean}
   */
  isAuthenticated() {
    return !!this.getToken()
  },

  /**
   * 保存用户信息
   * @param {Object} userInfo - 用户信息
   */
  setUserInfo(userInfo) {
    if (userInfo) {
      localStorage.setItem('userInfo', JSON.stringify(userInfo))
    }
  },

  /**
   * 获取用户信息
   * @returns {Object|null} 用户信息
   */
  getUserInfo() {
    const userInfo = localStorage.getItem('userInfo')
    return userInfo ? JSON.parse(userInfo) : null
  },

  /**
   * 移除用户信息
   */
  removeUserInfo() {
    localStorage.removeItem('userInfo')
  },

  /**
   * 清除所有认证信息（登出）
   */
  logout() {
    this.removeToken()
    this.removeUserInfo()
    localStorage.removeItem('rememberedUsername')
  }
}
