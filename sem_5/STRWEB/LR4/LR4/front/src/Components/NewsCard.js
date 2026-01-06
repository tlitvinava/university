import React from 'react';

class NewsCard extends React.Component {
  state = {
    viewed: false
  };

  componentDidMount() {
    console.log('NewsCard смонтирован:', this.props.article.title);
  }

  handleMarkViewed = () => {
    this.setState({ viewed: true });
    console.log('Новость отмечена как прочитанная:', this.props.article.title);
  };

  render() {
    const { article, onOpen } = this.props;
    const { viewed } = this.state;

    return (
      <li className="service-item">
        <div className="service-info">
          <h3 className="service-name">{article.title}</h3>
          <p className="service-description">
            {article.summary || 'Краткое описание отсутствует'}
          </p>
          <div className="service-actions">
            <button
              type="button"
              className="details-btn"
              onClick={() => onOpen(article)}
            >
              Читать полностью
            </button>
            <button
              type="button"
              className="btn-secondary"
              onClick={this.handleMarkViewed}
            >
              {viewed ? 'Прочитано' : 'Отметить как прочитанное'}
            </button>
          </div>
        </div>
      </li>
    );
  }
}

export default NewsCard;
