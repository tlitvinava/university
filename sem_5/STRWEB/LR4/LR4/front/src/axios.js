import axios from 'axios';

// Установите базовый URL для всех запросов
const instance = axios.create({
    baseURL: 'http://localhost:3001/', // Это пример. Замените на ваш серверный адрес
    headers: {
        'Content-Type': 'application/json',
    },
});

instance.interceptors.request.use(
    (config) => {
        // Get the token from localStorage
        const token = localStorage.getItem('authToken');

        // If the token exists, add it to the Authorization header
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }

        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

export default instance;
