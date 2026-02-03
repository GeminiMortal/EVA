import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
});

// 请求拦截器
api.interceptors.request.use(
  (config) => {
    // 可以在这里添加认证 token
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// 响应拦截器
api.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => {
    console.error('API Error:', error);
    return Promise.reject(error);
  }
);

export const userApi = {
  createUser: (userData) => api.post('/users/', userData),
  getUser: (userId) => api.get(`/users/${userId}`),
};

export const personalityApi = {
  createPersonality: (userId, personalityData) => 
    api.post(`/users/${userId}/personalities/`, personalityData),
  getPersonalities: (userId) => 
    api.get(`/users/${userId}/personalities/`),
  getActivePersonality: (userId) => 
    api.get(`/users/${userId}/personalities/active`),
  activatePersonality: (userId, personalityId) => 
    api.put(`/users/${userId}/personalities/${personalityId}/activate`),
  updatePersonality: (userId, personalityId, personalityData) => 
    api.put(`/users/${userId}/personalities/${personalityId}`, personalityData),
  deletePersonality: (userId, personalityId) => 
    api.delete(`/users/${userId}/personalities/${personalityId}`),
  clonePersonality: (userId, personalityId, newName) => 
    api.post(`/users/${userId}/personalities/${personalityId}/clone`, { name: newName }),
  getPersonalityTemplates: () => 
    api.get('/personality-templates/'),
};

export const conversationApi = {
  addMessage: (userId, messageData, personalityId = null) => 
    api.post(`/users/${userId}/conversations/`, messageData, {
      params: { personality_id: personalityId }
    }),
  getHistory: (userId, limit = 50) => 
    api.get(`/users/${userId}/conversations/`, { params: { limit } }),
};

export const analysisApi = {
  getPersonalityAnalysis: (userId, personalityId) => 
    api.get(`/users/${userId}/personalities/${personalityId}/analysis`),
  getCompatibilityReport: (userId, personalityId1, personalityId2) => 
    api.get(`/users/${userId}/compatibility/${personalityId1}/${personalityId2}`),
};

export default api;