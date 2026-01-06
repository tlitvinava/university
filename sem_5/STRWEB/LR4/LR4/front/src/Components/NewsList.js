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
        summary: 'Только до конца месяца действует скидка 50% на замену масла.',
        content: 'Мы используем сертифицированные масла ведущих производителей.',
        image: '/images/deposit.png'
    },
    {
        id: 3,
        title: 'Новый стенд для развала-схождения',
        summary: 'В автосервисе установлен современный стенд для развала-схождения.',
        content: 'Это позволяет выполнять регулировку подвески максимально точно.',
        image: '/images/stand.jpg'
    },
    {
        id: 4,
        title: 'Акция на шиномонтаж',
        summary: 'При покупке комплекта шин шиномонтаж бесплатно.',
        content: 'Акция действует до конца сезона.',
        image: '/images/action.png'
    },
    {
        id: 5,
        title: 'Новый специалист по электрике',
        summary: 'К нашей команде присоединился опытный автоэлектрик.',
        content: 'Теперь мы выполняем сложные работы по ремонту электрооборудования.',
        image: '/images/master.jpg'
    },
    {
        id: 6,
        title: 'Диагностика кондиционеров',
        summary: 'Запущена услуга диагностики и заправки кондиционеров.',
        content: 'Мы используем современное оборудование и сертифицированные хладагенты.',
        image: '/images/condition.jpg'
    },
    {
        id: 7,
        title: 'Обновление зоны ожидания',
        summary: 'Для клиентов обновлена зона ожидания с Wi-Fi и кофе.',
        content: 'Мы заботимся о вашем комфорте.',
        image: '/images/zone.jpg'
    },
    {
        id: 8,
        title: 'Скидка студентам',
        summary: 'Студенты получают скидку 15% на все услуги.',
        content: 'Для получения скидки достаточно предъявить студенческий билет.',
        image: '/images/student.jpg'
    },
    {
        id: 9,
        title: 'Новый инструмент для диагностики подвески',
        summary: 'Закуплено новое оборудование для диагностики подвески.',
        content: 'Это позволяет выявлять неисправности быстрее и точнее.',
        image: '/images/pod.jpg'
    },
    {
        id: 10,
        title: 'Программа лояльности',
        summary: 'Запущена программа лояльности для постоянных клиентов.',
        content: 'Теперь за каждое посещение начисляются бонусы.',
        image: '/images/loyalty.jpg'
    }
];

// const NewsList = () => {
//     const [expandedId, setExpandedId] = useState(null);

//     const toggleExpand = (id) => {
//         setExpandedId(expandedId === id ? null : id);
//     };

//     return (
//         <div className="news-list-container">
//             <h2 className="news-list-title">Новости автосервиса</h2>
//             <div className="news-grid">
//                 {sampleNews.map((newsItem) => (
//                     <div key={newsItem.id} className="news-card">
//                         {newsItem.image && (
//                             <img className="news-card-image" src={newsItem.image} alt={newsItem.title} />
//                         )}
//                         <h3 className="news-card-title">{newsItem.title}</h3>
//                         <p className="news-card-summary">{newsItem.summary}</p>
//                         {expandedId === newsItem.id && (
//                             <p className="news-card-content">{newsItem.content}</p>
//                         )}
//                         <button
//                             className="read-more-button"
//                             onClick={() => toggleExpand(newsItem.id)}
//                         >
//                             {expandedId === newsItem.id ? 'Скрыть' : 'Читать далее'}
//                         </button>
//                     </div>
//                 ))}
//             </div>
//         </div>
//     );
// };

// export default NewsList;


class NewsCard extends React.Component {
  state = {
    viewed: false
  };

  componentDidMount() {
    console.log('NewsCard смонтирован:', this.props.news.title);
  }

  handleMarkViewed = () => {
    this.setState({ viewed: true });
    console.log('Новость отмечена как прочитанная:', this.props.news.title);
  };

  render() {
    const { news, expanded, onToggle } = this.props;
    const { viewed } = this.state;

    return (
      <div className="news-card">
        {news.image && (
          <img className="news-card-image" src={news.image} alt={news.title} />
        )}
        <h3 className="news-card-title">{news.title}</h3>
        <p className="news-card-summary">{news.summary}</p>
        {expanded && <p className="news-card-content">{news.content}</p>}
        <div className="news-actions">
          <button
            className="read-more-button"
            onClick={() => onToggle(news.id)}
          >
            {expanded ? 'Скрыть' : 'Читать далее'}
          </button>
          <button
            className="btn-secondary"
            onClick={this.handleMarkViewed}
          >
            {viewed ? 'Прочитано' : 'Отметить как прочитанное'}
          </button>
        </div>
      </div>
    );
  }
}

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
          <NewsCard
            key={newsItem.id}
            news={newsItem}
            expanded={expandedId === newsItem.id}
            onToggle={toggleExpand}
          />
        ))}
      </div>
    </div>
  );
};

export default NewsList;