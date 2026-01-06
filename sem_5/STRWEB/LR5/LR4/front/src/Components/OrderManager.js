// // src/components/OrderManager.js
// import React, { useReducer, useEffect, useState, useContext } from 'react';
// import axios from '../axios';
// import { useAuth } from '../context/AuthContext';
// import ServiceSelector from './presentational/ServiceSelector';
// import SparePartSelector from './presentational/SparePartSelector';
// import OrderSummary from './presentational/OrderSummary';

// const initialState = {
//   services: [],
//   spareParts: [],
//   selectedServiceIds: [],
//   selectedSparePartIds: [],
//   contactPhone: '',
//   scheduledDate: '',
//   status: 'pending',
//   notes: ''
// };

// function orderReducer(state, action) {
//   switch (action.type) {
//     case 'SET_DATA':
//       return { ...state, services: action.payload.services, spareParts: action.payload.spareParts };
//     case 'TOGGLE_SERVICE':
//       return {
//         ...state,
//         selectedServiceIds: state.selectedServiceIds.includes(action.id)
//           ? state.selectedServiceIds.filter(sid => sid !== action.id)
//           : [...state.selectedServiceIds, action.id]
//       };
//     case 'TOGGLE_SPARE':
//       return {
//         ...state,
//         selectedSparePartIds: state.selectedSparePartIds.includes(action.id)
//           ? state.selectedSparePartIds.filter(pid => pid !== action.id)
//           : [...state.selectedSparePartIds, action.id]
//       };
//     case 'SET_FIELD':
//       return { ...state, [action.field]: action.value };
//     case 'RESET':
//       return initialState;
//     default:
//       return state;
//   }
// }

// const OrderManager = () => {
//   const [state, dispatch] = useReducer(orderReducer, initialState);
//   const [loading, setLoading] = useState(true);
//   const [creating, setCreating] = useState(false);
//   const [error, setError] = useState('');
//   const { user } = useAuth(); // useContext внутри useAuth

//   // Load services and spare parts
//   useEffect(() => {
//     let active = true;
//     const load = async () => {
//       setLoading(true);
//       try {
//         const [servicesRes, partsRes] = await Promise.all([
//           axios.get('/api/additional-services', { params: { sortBy: 'name', sortOrder: 'asc' } }),
//           axios.get('/api/spare-parts', { params: { sortBy: 'name', sortOrder: 'asc' } })
//         ]);
//         if (!active) return;
//         dispatch({ type: 'SET_DATA', payload: { services: servicesRes.data, spareParts: partsRes.data } });
//       } catch (e) {
//         setError('Failed to load data');
//       } finally {
//         setLoading(false);
//       }
//     };
//     load();
//     return () => { active = false; };
//   }, []);

//   const handleSubmit = async (e) => {
//     e.preventDefault();
//     setCreating(true);
//     setError('');
//     try {
//       const body = {
//         customer: user?.id || user?._id, // зависит от твоего AuthContext
//         services: state.selectedServiceIds,
//         spare_parts: state.selectedSparePartIds,
//         total_cost: '0', // сервер может сам рассчитать; иначе рассчитай на фронте
//         status: state.status,
//         contact_phone: state.contactPhone,
//         scheduled_date: state.scheduledDate
//       };
//       const res = await axios.post('/api/orders', body);
//       dispatch({ type: 'RESET' });
//       alert('Order created: ' + res.data._id);
//     } catch (e) {
//       setError('Failed to create order');
//     } finally {
//       setCreating(false);
//     }
//   };

//   const handlePhoneChange = (e) => dispatch({ type: 'SET_FIELD', field: 'contactPhone', value: e.target.value });
//   const handleDateChange = (e) => dispatch({ type: 'SET_FIELD', field: 'scheduledDate', value: e.target.value });
//   const handleStatusChange = (e) => dispatch({ type: 'SET_FIELD', field: 'status', value: e.target.value });
//   const handleNotesChange = (e) => dispatch({ type: 'SET_FIELD', field: 'notes', value: e.target.value });

//   // Additional event handlers for the "minimum seven" requirement:
//   const handleNotesBlur = () => console.log('Notes blurred');
//   const handlePhoneFocus = () => console.log('Phone focused');
//   const handleKeyDown = (e) => { if (e.key === 'Enter') e.preventDefault(); }; // Prevent submit on Enter in some fields
//   const handleMouseEnterSubmit = () => console.log('Hover submit');

//   if (loading) return <p>Loading...</p>;
//   if (error) return <p style={{ color: 'red' }}>{error}</p>;

//   return (
//     <div className="order-list-container">
//       <h2 className="order-header">Create Order</h2>

//       <form onSubmit={handleSubmit} onKeyDown={handleKeyDown}>
//         <ServiceSelector
//           items={state.services}
//           selectedIds={state.selectedServiceIds}
//           onToggle={id => dispatch({ type: 'TOGGLE_SERVICE', id })}
//           onChangeSearch={() => {}}
//         />

//         <SparePartSelector
//           items={state.spareParts}
//           selectedIds={state.selectedSparePartIds}
//           onToggle={id => dispatch({ type: 'TOGGLE_SPARE', id })}
//         />

//         <div className="order-details">
//           <label>
//             Contact phone:
//             <input
//               type="tel"
//               value={state.contactPhone}
//               onChange={handlePhoneChange}
//               onFocus={handlePhoneFocus} // 1: onFocus
//               onBlur={() => console.log('Phone blur')} // 2: onBlur
//             />
//           </label>
//         </div>

//         <div className="order-details">
//           <label>
//             Scheduled date:
//             <input
//               type="datetime-local"
//               value={state.scheduledDate}
//               onChange={handleDateChange} // 3: onChange
//             />
//           </label>
//         </div>

//         <div className="order-details">
//           <label>
//             Status:
//             <select value={state.status} onChange={handleStatusChange}> {/* 4: onChange */}
//               <option value="pending">pending</option>
//               <option value="confirmed">confirmed</option>
//               <option value="cancelled">cancelled</option>
//               <option value="completed">completed</option>
//             </select>
//           </label>
//         </div>

//         <div className="order-details">
//           <label>
//             Notes:
//             <textarea
//               value={state.notes}
//               onChange={handleNotesChange} // 5: onChange
//               onBlur={handleNotesBlur} // 6: onBlur
//             />
//           </label>
//         </div>

//         <OrderSummary
//           services={state.services}
//           spareParts={state.spareParts}
//           selectedServiceIds={state.selectedServiceIds}
//           selectedSparePartIds={state.selectedSparePartIds}
//         />

//         <button
//           type="submit"
//           className="primary"
//           disabled={creating}
//           onMouseEnter={handleMouseEnterSubmit} // 7: onMouseEnter
//           onClick={() => console.log('Submitting order')} // 8: onClick
//         >
//           {creating ? 'Creating...' : 'Create Order'}
//         </button>
//       </form>
//     </div>
//   );
// };

// export default OrderManager;


// src/components/OrderManager.js
import React, { useReducer, useEffect, useState } from 'react';
import axios from '../axios';
import { useAuth } from '../context/AuthContext';
import ServiceSelector from './presentational/ServiceSelector';
import SparePartSelector from './presentational/SparePartSelector';
import OrderSummary from './presentational/OrderSummary';

const initialState = {
  services: [],
  spareParts: [],
  selectedServiceIds: [],
  selectedSparePartIds: [],
  contactPhone: '',
  scheduledDate: '',
  status: 'pending',
  notes: ''
};

function orderReducer(state, action) {
  switch (action.type) {
    case 'SET_DATA':
      return { ...state, services: action.payload.services, spareParts: action.payload.spareParts };
    case 'TOGGLE_SERVICE':
      return {
        ...state,
        selectedServiceIds: state.selectedServiceIds.includes(action.id)
          ? state.selectedServiceIds.filter(sid => sid !== action.id)
          : [...state.selectedServiceIds, action.id]
      };
    case 'TOGGLE_SPARE':
      return {
        ...state,
        selectedSparePartIds: state.selectedSparePartIds.includes(action.id)
          ? state.selectedSparePartIds.filter(pid => pid !== action.id)
          : [...state.selectedSparePartIds, action.id]
      };
    case 'SET_FIELD':
      return { ...state, [action.field]: action.value };
    case 'RESET':
      return initialState;
    default:
      return state;
  }
}

const OrderManager = () => {
  const [state, dispatch] = useReducer(orderReducer, initialState);
  const [loading, setLoading] = useState(true);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState('');
  const [orders, setOrders] = useState([]);
  const { user } = useAuth();

  // Загружаем услуги и запчасти
  useEffect(() => {
    let active = true;
    const load = async () => {
      setLoading(true);
      try {
        const [servicesRes, partsRes] = await Promise.all([
          axios.get('/api/additional-services'),
          axios.get('/api/spare-parts')
        ]);
        if (!active) return;
        dispatch({ type: 'SET_DATA', payload: { services: servicesRes.data, spareParts: partsRes.data } });
      } catch (e) {
        setError('Ошибка загрузки данных');
      } finally {
        setLoading(false);
      }
    };
    load();
    return () => { active = false; };
  }, []);

  // Загружаем список заказов
  useEffect(() => {
    axios.get('/api/orders')
      .then(res => setOrders(res.data))
      .catch(err => console.error('Ошибка загрузки заказов:', err));
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setCreating(true);
    setError('');
    try {
      // считаем стоимость
      const servicesTotal = state.services
        .filter(s => state.selectedServiceIds.includes(s._id))
        .reduce((sum, s) => sum + Number(s.cost?.$numberDecimal || s.cost || 0), 0);

      const partsTotal = state.spareParts
        .filter(p => state.selectedSparePartIds.includes(p._id))
        .reduce((sum, p) => sum + Number(p.price?.$numberDecimal || p.price || 0), 0);

      const total = servicesTotal + partsTotal;

      const body = {
        customer: user?._id,
        services: state.selectedServiceIds,
        spare_parts: state.selectedSparePartIds,
        total_cost: total,
        status: state.status,
        contact_phone: state.contactPhone,
        scheduled_date: state.scheduledDate
      };

      const res = await axios.post('/api/orders', body, {
        headers: { Authorization: `Bearer ${localStorage.getItem('authToken')}` }
      });

      dispatch({ type: 'RESET' });
      alert('Заказ создан: ' + res.data._id);

      // обновляем список заказов
      const updatedOrders = await axios.get('/api/orders');
      setOrders(updatedOrders.data);

    } catch (e) {
      setError('Ошибка при создании заказа: ' + e.message);
    } finally {
      setCreating(false);
    }
  };

  if (loading) return <p>Загрузка...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;

  return (
    <div className="order-list-container">
      <h2 className="order-header">Создать заказ</h2>

      <form onSubmit={handleSubmit}>
        <ServiceSelector
          items={state.services}
          selectedIds={state.selectedServiceIds}
          onToggle={id => dispatch({ type: 'TOGGLE_SERVICE', id })}
        />

        <SparePartSelector
          items={state.spareParts}
          selectedIds={state.selectedSparePartIds}
          onToggle={id => dispatch({ type: 'TOGGLE_SPARE', id })}
        />

        <div className="order-details">
          <label>
            Телефон:
            <input
              type="tel"
              value={state.contactPhone}
              onChange={e => dispatch({ type: 'SET_FIELD', field: 'contactPhone', value: e.target.value })}
            />
          </label>
        </div>

        <div className="order-details">
          <label>
            Дата:
            <input
              type="datetime-local"
              value={state.scheduledDate}
              onChange={e => dispatch({ type: 'SET_FIELD', field: 'scheduledDate', value: e.target.value })}
            />
          </label>
        </div>

        <div className="order-details">
          <label>
            Статус:
            <select
              value={state.status}
              onChange={e => dispatch({ type: 'SET_FIELD', field: 'status', value: e.target.value })}
            >
              <option value="pending">pending</option>
              <option value="confirmed">confirmed</option>
              <option value="cancelled">cancelled</option>
              <option value="completed">completed</option>
            </select>
          </label>
        </div>

        <OrderSummary
          services={state.services}
          spareParts={state.spareParts}
          selectedServiceIds={state.selectedServiceIds}
          selectedSparePartIds={state.selectedSparePartIds}
        />

        <button type="submit" disabled={creating}>
          {creating ? 'Создание...' : 'Создать заказ'}
        </button>
      </form>

      <h2 className="order-header">Список заказов</h2>
      <ul>
        {orders.map(order => (
          <li key={order._id}>
            {order.customer?.email} — {order.status} — {order.total_cost?.$numberDecimal || order.total_cost}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default OrderManager;
