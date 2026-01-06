import React, { useState, useEffect } from 'react';
import axios from '../axios';
import { Link } from 'react-router-dom';
import './Styles/TicketList.css';

const TicketList = () => {
    const [tickets, setTickets] = useState([]);

    useEffect(() => {
        fetchTickets();
    }, );

    const fetchTickets = () => {
        axios
            .get('/api/tickets', )
            .then((response) => setTickets(response.data))
            .catch((error) => console.error('Error fetching tickets:', error));
    };

    const handleDelete = (id) => {
        axios
            .delete(`/api/tickets/${id}`)
            .then(() => {
                setTickets(tickets.filter((ticket) => ticket._id !== id));
            })
            .catch((error) => console.error('Error deleting ticket:', error));
        window.location.reload();
    };

    return (
        <div className="ticket-list-container">
            <h2>Tickets List</h2>
            <ul className="ticket-list">
                {tickets.map((ticket) => (
                    <li key={ticket._id} className="ticket-item">
                        <div className="ticket-info">
                            <strong className="ticket-date-purchase">Date of Purchase: {new Date(ticket.date_of_purchase).toLocaleString()}</strong>
                            <p>Number of Attendees: {ticket.number_of_attendees}</p>
                            <p>Contact Phone: {ticket.contact_phone_number}</p>
                            <p>Date of Attendance: {new Date(ticket.date_of_attendance).toLocaleString()}</p>
                            <p>Status: {ticket.status}</p>
                            <p>Overall Cost: ${ticket.overall_cost.$numberDecimal}</p>
                            <p>Promo Code: {ticket.promo_code}</p>
                        </div>
                    </li>
                ))}
            </ul>
            {tickets.length === 0 && <p>No tickets found.</p>}
        </div>
    );
};

export default TicketList;
