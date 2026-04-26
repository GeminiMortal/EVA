// API 基础配置
const API_BASE_URL = 'http://localhost:8080/api'

/**
 * 封装 fetch 请求
 */
class HttpClient {
  constructor(baseURL) {
    this.baseURL = baseURL
  }

  /**
   * 获取请求头
   */
  getHeaders() {
    const headers = {
      'Content-Type': 'application/json'
    }
    
    const token = localStorage.getItem('token')
    if (token) {
      headers['Authorization'] = `Bearer ${token}`
    }
    
    return headers
  }

  /**
   * GET 请求
   */
  async get(url, params = {}) {
    const queryString = new URLSearchParams(params).toString()
    const fullUrl = queryString ? `${this.baseURL}${url}?${queryString}` : `${this.baseURL}${url}`
    
    const response = await fetch(fullUrl, {
      method: 'GET',
      headers: this.getHeaders()
    })
    
    return this.handleResponse(response)
  }

  /**
   * POST 请求
   */
  async post(url, data = {}) {
    const response = await fetch(`${this.baseURL}${url}`, {
      method: 'POST',
      headers: this.getHeaders(),
      body: JSON.stringify(data)
    })
    
    return this.handleResponse(response)
  }

  /**
   * PUT 请求
   */
  async put(url, data = {}) {
    const response = await fetch(`${this.baseURL}${url}`, {
      method: 'PUT',
      headers: this.getHeaders(),
      body: JSON.stringify(data)
    })
    
    return this.handleResponse(response)
  }

  /**
   * DELETE 请求
   */
  async delete(url) {
    const response = await fetch(`${this.baseURL}${url}`, {
      method: 'DELETE',
      headers: this.getHeaders()
    })
    
    return this.handleResponse(response)
  }

  /**
   * 处理响应
   */
  async handleResponse(response) {
    if (!response.ok) {
      const error = await response.json().catch(() => ({ message: '网络错误' }))
      throw new Error(error.message || `HTTP error! status: ${response.status}`)
    }
    
    const data = await response.json()
    
    // 如果后端返回统一格式 { code, message, data }
    if (data.code !== undefined) {
      if (data.code === 200) {
        return data.data
      } else {
        throw new Error(data.message || '请求失败')
      }
    }
    
    return data
  }
}

// 创建实例
const http = new HttpClient(API_BASE_URL)

export default http
