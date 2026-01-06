import React, { useState } from 'react';
import axios from '../axios';
import { useNavigate } from 'react-router-dom';
import './Styles/AddService.css';

const AddService = () => {
    const [name, setName] = useState('');
    const [description, setDescription] = useState('');
    const [cost, setCost] = useState('');
    const [available, setAvailable] = useState(true);
    const [duration, setDuration] = useState('');

    const navigate = useNavigate();

    const handleSubmit = (e) => {
        e.preventDefault();
        const newService = { name, description, cost, available, duration_minutes: duration };

        axios.post('/api/additional-services', newService)
            .then(() => {
                navigate('/');
            })
            .catch(error => console.error('Error adding service:', error));
    };

    return (
        <div className="add-service-container">
            <h2>Add New Service</h2>
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
                <button type="submit">Add Service</button>
            </form>
        </div>
    );
};

export default AddService;
