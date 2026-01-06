import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from '../axios';
import './Styles/Auth.css';

const Signup = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await axios.post('/api/auth/register', { email, password });
            navigate('/login');
        } catch (err) {
            setError('Signup failed');
        }
    };

    return (
        <div className="auth-container">
            <h2>Signup</h2>
            {error && <p className="error">{error}</p>}
            <form onSubmit={handleSubmit}>
                <input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                />
                <input
                    type="password"
                    placeholder="Password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                />
                <button type="submit">Signup</button>
            </form>
        </div>
    );
};

export default Signup;
