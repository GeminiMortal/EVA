const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 8080,
    host: 'localhost',
    open: true, // 自动打开浏览器
    proxy: {
      '/api': {
        target: 'http://localhost:5136', // 后端地址
        changeOrigin: true,
        ws: true, // 支持 WebSocket 长连接
        timeout: 120000, // 超时时间 2 分钟
        proxyTimeout: 120000,
        headers: {
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=60'
        }
      }
    }
  }
})
