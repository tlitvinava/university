// import React, { createContext, useContext, useState, useEffect } from 'react';

// // Create the AuthContext
// const AuthContext = createContext();

// // AuthProvider Component
// export const AuthProvider = ({ children }) => {
//     const [user, setUser] = useState(() => {
//         const token = localStorage.getItem('authToken');
//         return token ? { email: 'user@example.com' } : null; // Simulate user if token exists
//     });

//     // Check localStorage or refresh token on app load
//     useEffect(() => {
//         const token = localStorage.getItem('authToken');
//         if (token) {
//             // Optional: Add logic to verify token (e.g., decode JWT or fetch user info)
//             setUser({ email: 'user@example.com' }); // Example user for demo
//         } else {
//             setUser(null);
//         }
//     }, []);

//     // Login function
//     const login = (email, token) => {
//         if (!email || !token) {
//             console.error('Invalid login data.');
//             return;
//         }
//         localStorage.setItem('authToken', token); // Save token in localStorage
//         setUser({ email }); // Simulate user object
//     };

//     // Logout function
//     const logout = () => {
//         localStorage.removeItem('authToken'); // Clear token
//         setUser(null); // Clear user state
//     };

//     return (
//         <AuthContext.Provider value={{ user, login, logout }}>
//             {children}
//         </AuthContext.Provider>
//     );
// };

// // Custom Hook to Use Auth Context
// export const useAuth = () => {
//     const context = useContext(AuthContext);
//     if (!context) {
//         throw new Error('useAuth must be used within an AuthProvider');
//     }
//     return context;
// };

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
