import logo from './logo.svg';
// import './App.css';
import './Components/index.css'

import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import ServiceList from './Components/ServiceList';
import AddService from './Components/AddService';
import EditService from './Components/EditService';
import CatBreedsList from "./Components/CatBreeds";
import DogBreedsList from "./Components/DogBreedList";
import TimeInfo from "./Components/TimeInfo";
import Login from './Components/Login';
import Signup from './Components/Signup';
import Navbar from './Components/NavBar';
import NewsList from './Components/NewsList';
import SparePartInventory from './Components/SparePartInventory';
import TicketList from "./Components/TicketList";
import { AuthProvider, useAuth } from './context/AuthContext';
import OrderManager from './Components/OrderManager';

const ProtectedRoute = ({ element, ...rest }) => {
    const { user } = useAuth();
    return user ? element : <navigate to="/login" />;
};

function App() {
    return (
        <AuthProvider>
            <div>
                <Router>
                    <Navbar />
                    <Routes>
                        <Route path="/" element={<ServiceList />} />
                        <Route path="/newsList" element={<NewsList />} />
                        <Route path='/ticketList' element={<TicketList />} />
                        <Route path="/add" element={<ProtectedRoute element={<AddService />} />} />
                        <Route path="/edit/:id" element={<ProtectedRoute element={<EditService />} />} />
                        <Route path="/spare-parts" element={<SparePartInventory />} />
                        <Route path="/orders" element={<OrderManager/>}/>
                        <Route path="/login" element={<Login />} />
                        <Route path="/signup" element={<Signup />} />
                    </Routes>
                </Router>
                <TimeInfo></TimeInfo>
            </div>
        </AuthProvider>
    );
}

export default App;
//
//
// function App() {
//   return (
//     <div className="App">
//         <header className="App-header">
//             <nav>
//                 <button id={'but'} onClick={() => {alert('works')}}>Push me</button>
//             </nav>
//             <img src={logo} className="App-logo" alt="logo"/>
//             <p>
//                 Edit <code>src/App.js</code> and save to reload.
//             </p>
//             <a
//                 className="App-link"
//                 href="https://reactjs.org"
//                 target="_blank"
//                 rel="noopener noreferrer"
//             >
//                 Learn React
//             </a>
//         </header>
//     </div>
//   );
// }
//
// export default App;
