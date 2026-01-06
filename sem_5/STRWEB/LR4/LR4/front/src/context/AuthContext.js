import React, { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(() => {
        const token = localStorage.getItem('authToken');
        const id = localStorage.getItem('userId');
        const email = localStorage.getItem('userEmail');
        return token && id ? { _id: id, email } : null;
    });

    useEffect(() => {
        const token = localStorage.getItem('authToken');
        const id = localStorage.getItem('userId');
        const email = localStorage.getItem('userEmail');
        if (token && id) {
            setUser({ _id: id, email });
        } else {
            setUser(null);
        }
    }, []);

    const login = (email, token, id) => {
        if (!email || !token || !id) {
            console.error('Invalid login data.');
            return;
        }
        localStorage.setItem('authToken', token);
        localStorage.setItem('userId', id);
        localStorage.setItem('userEmail', email);
        setUser({ _id: id, email });
    };

    const logout = () => {
        localStorage.removeItem('authToken');
        localStorage.removeItem('userId');
        localStorage.removeItem('userEmail');
        setUser(null);
    };

    return (
        <AuthContext.Provider value={{ user, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
};
