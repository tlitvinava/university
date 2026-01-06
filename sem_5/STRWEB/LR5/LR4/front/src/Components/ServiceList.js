import React, { useState, useEffect } from 'react';
import axios from '../axios';
import { Link } from 'react-router-dom';
import './Styles/ServiceList.css';

const ServiceList = () => {
    const [services, setServices] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');
    const [sortBy, setSortBy] = useState('name'); // Default sort field
    const [sortOrder, setSortOrder] = useState('asc'); // Default sort order
    const [user, setUser] = useState(null); // состояние для текущего пользователя

    useEffect(() => {
        // Проверка, авторизован ли пользователь (можно использовать контекст или глобальное состояние)
        const currentUser = JSON.parse(localStorage.getItem('user')); // Пример из локального хранилища
        setUser(currentUser);

        fetchServices();
    }, [searchQuery, sortBy, sortOrder]);

    const fetchServices = () => {
        // Fetch services with search and sorting applied
        axios
            .get('/api/additional-services', {
                params: {
                    search: searchQuery,
                    sortBy,
                    sortOrder,
                },
            })
            .then((response) => setServices(response.data))
            .catch((error) => console.error('Error fetching services:', error));
    };

    const handleDelete = (id) => {
        if (window.confirm("Are you sure you want to delete this service?")) {
            axios
                .delete(`/api/additional-services/${id}`)
                .then(() => {
                    setServices(services.filter((service) => service._id !== id));
                })
                .catch((error) => console.error('Error deleting service:', error));
        }
    };

    return (
        <div className="service-list-container">
            <h2>Services List</h2>
            <div className="controls">
                <input
                    type="text"
                    placeholder="Search services..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="search-input"
                />
                <div className="sort-controls">
                    <label>Sort By:</label>
                    <select value={sortBy} onChange={(e) => setSortBy(e.target.value)}>
                        <option value="name">Name</option>
                        <option value="createdAt">Date Added</option>
                        <option value="updatedAt">Last Updated</option>
                    </select>
                    <select value={sortOrder} onChange={(e) => setSortOrder(e.target.value)}>
                        <option value="asc">Ascending</option>
                        <option value="desc">Descending</option>
                    </select>
                </div>
            </div>

            {localStorage.getItem('authToken') && ( // Показываем кнопку добавления для всех зарегистрированных пользователей
                <Link to="/add" className="add-service-link">Add New Service</Link>
            )}

            <ul className="service-list">
                {services.map((service) => (
                    <li key={service._id} className="service-item">
                        <div className="service-info">
                            <strong className="service-name">{service.name}</strong>
                            <p>{service.description}</p>
                            <p>Cost: {service.cost}</p>
                            <p>Duration: {service.duration_minutes} minutes</p>
                            <p>Status: {service.available ? 'Available' : 'Unavailable'}</p>
                        </div>
                        <div className="service-actions">
                            {localStorage.getItem('authToken') && ( // Показываем кнопки "Изменить" и "Удалить" для всех зарегистрированных пользователей
                                <>
                                    <Link to={`/edit/${service.id}`} className="edit-button">Edit</Link>
                                    <button
                                        onClick={() => handleDelete(service.id)}
                                        className="delete-button"
                                    >
                                        Delete
                                    </button>
                                </>
                            )}
                        </div>
                    </li>
                ))}
            </ul>
            {services.length === 0 && <p>No services found.</p>}
        </div>
    );
};

export default ServiceList;
