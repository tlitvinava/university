// import React, { useState, useEffect } from 'react';
// import axios from '../axios'; // Путь к вашему axios экземпляру
// import './Styles/NewsList.css'; // Импортируем файл CSS

// const NewsList = () => {
//     const [news, setNews] = useState([]);

//     useEffect(() => {
//         // Загружаем новости при монтировании компонента
//         axios.get('/api/news') // Предположим, что этот рут возвращает список новостей
//             .then((response) => setNews(response.data))
//             .catch((error) => console.error('Ошибка загрузки новостей:', error));
//     }, []);

//     return (
//         <div className="news-list-container">
//             <h2 className="news-list-title">Новости автосервиса</h2>
//             <ul className="news-list">
//                 {news.map((newsItem) => (
//                     <li key={newsItem.id} className="news-item">
//                         <h3 className="news-item-title">{newsItem.title}</h3>
//                         <p className="news-item-summary"><strong>Сводка:</strong> {newsItem.summary}</p>
//                         <p className="news-item-content">{newsItem.content}</p>
//                         {newsItem.image && <img className="news-item-image" src={newsItem.image} alt={newsItem.title} />}
//                     </li>
//                 ))}
//             </ul>
//         </div>
//     );
// };

// export default NewsList;

import React, { useState } from 'react';
import './Styles/NewsList.css';

const sampleNews = [
    {
        id: 1,
        title: 'Новый сервис диагностики двигателя',
        summary: 'Мы запустили современную диагностику двигателя для всех марок автомобилей.',
        content: 'Теперь клиенты могут получить точный отчёт о состоянии мотора за считанные минуты.',
        image: '/images/engine-diagnostic.jpg'
    },
    {
        id: 2,
        title: 'Скидка на замену масла',
        summary: 'Только до конца месяца действует скидка 20% на замену масла.',
        content: 'Мы используем сертифицированные масла ведущих производителей.',
        image: 'https://images.unsplash.com/photo-1615732047590-9b6c1f3d3c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 3,
        title: 'Новый стенд для развала-схождения',
        summary: 'В автосервисе установлен современный стенд для развала-схождения.',
        content: 'Это позволяет выполнять регулировку подвески максимально точно.',
        image: 'https://images.unsplash.com/photo-1605719124093-6f3b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 4,
        title: 'Акция на шиномонтаж',
        summary: 'При покупке комплекта шин шиномонтаж бесплатно.',
        content: 'Акция действует до конца сезона.',
        image: 'https://images.unsplash.com/photo-1581091870620-1e7b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 5,
        title: 'Новый специалист по электрике',
        summary: 'К нашей команде присоединился опытный автоэлектрик.',
        content: 'Теперь мы выполняем сложные работы по ремонту электрооборудования.',
        image: 'https://images.unsplash.com/photo-1581090700227-1e7b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 6,
        title: 'Диагностика кондиционеров',
        summary: 'Запущена услуга диагностики и заправки кондиционеров.',
        content: 'Мы используем современное оборудование и сертифицированные хладагенты.',
        image: 'https://images.unsplash.com/photo-1605719124093-6f3b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 7,
        title: 'Обновление зоны ожидания',
        summary: 'Для клиентов обновлена зона ожидания с Wi-Fi и кофе.',
        content: 'Мы заботимся о вашем комфорте.',
        image: 'https://images.unsplash.com/photo-1605719124093-6f3b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 8,
        title: 'Скидка студентам',
        summary: 'Студенты получают скидку 15% на все услуги.',
        content: 'Для получения скидки достаточно предъявить студенческий билет.',
        image: 'https://images.unsplash.com/photo-1581091870620-1e7b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 9,
        title: 'Новый инструмент для диагностики подвески',
        summary: 'Закуплено новое оборудование для диагностики подвески.',
        content: 'Это позволяет выявлять неисправности быстрее и точнее.',
        image: 'https://images.unsplash.com/photo-1581090700227-1e7b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    },
    {
        id: 10,
        title: 'Программа лояльности',
        summary: 'Запущена программа лояльности для постоянных клиентов.',
        content: 'Теперь за каждое посещение начисляются бонусы.',
        image: 'https://images.unsplash.com/photo-1605719124093-6f3b1f1e1c2e?auto=format&fit=crop&w=800&q=80'
    }
];

const NewsList = () => {
    const [expandedId, setExpandedId] = useState(null);

    const toggleExpand = (id) => {
        setExpandedId(expandedId === id ? null : id);
    };

    return (
        <div className="news-list-container">
            <h2 className="news-list-title">Новости автосервиса</h2>
            <div className="news-grid">
                {sampleNews.map((newsItem) => (
                    <div key={newsItem.id} className="news-card">
                        {newsItem.image && (
                            <img className="news-card-image" src={newsItem.image} alt={newsItem.title} />
                        )}
                        <h3 className="news-card-title">{newsItem.title}</h3>
                        <p className="news-card-summary">{newsItem.summary}</p>
                        {expandedId === newsItem.id && (
                            <p className="news-card-content">{newsItem.content}</p>
                        )}
                        <button
                            className="read-more-button"
                            onClick={() => toggleExpand(newsItem.id)}
                        >
                            {expandedId === newsItem.id ? 'Скрыть' : 'Читать далее'}
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default NewsList;
