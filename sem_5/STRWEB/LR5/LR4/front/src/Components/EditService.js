import React, { useState, useEffect } from 'react';
import axios from '../axios';
import { useNavigate, useParams } from 'react-router-dom';
import './Styles/EditService.css';

const EditService = () => {
    const [service, setService] = useState(null);
    const [name, setName] = useState('');
    const [description, setDescription] = useState('');
    const [cost, setCost] = useState('');
    const [available, setAvailable] = useState(true);
    const [duration, setDuration] = useState('');

    const { id } = useParams();
    const navigate = useNavigate();

    useEffect(() => {
        // Получаем данные услуги для редактирования
        axios.get(`/api/additional-services/${id}`)
            .then(response => {
                const serviceData = response.data;
                setService(serviceData);
                setName(serviceData.name);
                setDescription(serviceData.description);
                setCost(serviceData.cost);
                setAvailable(serviceData.available);
                setDuration(serviceData.duration_minutes);
            })
            .catch(error => console.error('Error fetching service data:', error));
    }, [id]);

    const handleSubmit = (e) => {
        e.preventDefault();
        const updatedService = { name, description, cost, available, duration_minutes: duration };

        axios.put(`/api/additional-services/${id}`, updatedService)
            .then(() => {
                navigate('/');
            })
            .catch(error => console.error('Error updating service:', error));
    };

    if (!service) return <div>Loading...</div>;

    return (
        <div className="edit-service-container">
            <h2>Edit Service</h2>
            <form onSubmit={handleSubmit}>
                <div>
                    <label>Name:</label>
                    <input type="text" value={name} onChange={(e) => setName(e.target.value)} required />
                </div>
                <div>
                    <label>Description:</label>
                    <textarea value={description} onChange={(e) => setDescription(e.target.value)} required />
                </div>
                <div>
                    <label>Cost:</label>
                    <input type="number" value={cost} onChange={(e) => setCost(e.target.value)} required />
                </div>
                <div>
                    <label>Available:</label>
                    <input type="checkbox" checked={available} onChange={(e) => setAvailable(e.target.checked)} />
                </div>
                <div>
                    <label>Duration (in minutes):</label>
                    <input type="number" value={duration} onChange={(e) => setDuration(e.target.value)} required />
                </div>
                <button type="submit">Update Service</button>
            </form>
        </div>
    );
};

export default EditService;
