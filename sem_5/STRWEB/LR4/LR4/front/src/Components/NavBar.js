import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './Styles/Navbar.css';

const Navbar = () => {
    const { user, logout } = useAuth();
    const navigate = useNavigate();

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    return (
        <nav className="navbar">
            <div className="navbar-links">
                <Link to="/">Services</Link>
                <Link to="/newsList">News</Link>
                <Link to="/orders">Orders</Link>
                <Link to="/spare-parts">Spare Parts</Link>
                {user && <Link to="/add">Add Service</Link>}
            </div>
            <div className="navbar-auth">
                {user ? (
                    <>
                        <span>Welcome, {user.email}</span>
                        <button onClick={handleLogout}>Logout</button>
                    </>
                ) : (
                    <>
                        <Link to="/login">Login</Link>
                        <Link to="/signup">Signup</Link>
                    </>
                )}
            </div>
        </nav>
    );
};

export default Navbar;
