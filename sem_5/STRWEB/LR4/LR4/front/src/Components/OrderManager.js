import React, { useReducer, useEffect, useState } from 'react';
import axios from '../axios';
import { useAuth } from '../context/AuthContext';
import './Styles/OrderManager.css';

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
    case 'SET_DATA': {
      console.log('[reducer] SET_DATA: services count =', (action.payload.services || []).length,
                  'spareParts count =', (action.payload.spareParts || []).length);
      return { ...state, services: action.payload.services || [], spareParts: action.payload.spareParts || [] };
    }

    case 'TOGGLE_SERVICE': {
      const isSelected = state.selectedServiceIds.includes(action.id);
      const newSelected = isSelected
        ? state.selectedServiceIds.filter(sid => sid !== action.id)
        : [...state.selectedServiceIds, action.id];
      console.log('[reducer] TOGGLE_SERVICE:', { clickedId: action.id, wasSelected: isSelected, newSelected });
      return { ...state, selectedServiceIds: newSelected };
    }

    case 'TOGGLE_SPARE': {
      const isSelected = state.selectedSparePartIds.includes(action.id);
      const newSpareIds = isSelected
        ? state.selectedSparePartIds.filter(pid => pid !== action.id)
        : [...state.selectedSparePartIds, action.id];
      console.log('[reducer] TOGGLE_SPARE:', { clickedId: action.id, wasSelected: isSelected, newSpareIds });
      return { ...state, selectedSparePartIds: newSpareIds };
    }

    case 'SET_FIELD':
      console.log('[reducer] SET_FIELD:', action.field, '=', action.value);
      return { ...state, [action.field]: action.value };

    case 'RESET':
      console.log('[reducer] RESET -> initialState');
      return initialState;

    default:
      return state;
  }
}

const normalizeServices = (arr = []) => {
  return arr.map((s, i) => {
    const rawId = s?._id ?? s?.id;
    const id = rawId ? String(rawId) : `tmp-service-${i}`;
    const status = (s?.status ?? '').toString().toLowerCase();
    const available = typeof s?.available === 'boolean' ? s.available : true;
    return {
      ...s,
      _id: id,
      status,
      available
    };
  });
};

const normalizeParts = (arr = []) => {
  return arr.map((p, i) => {
    const rawId = p?._id ?? p?.id;
    const id = rawId ? String(rawId) : `tmp-part-${i}`;
    return {
      ...p,
      _id: id
    };
  });
};

const isServiceRenderable = (service) => {
  if (!service) return false;
  const status = (service.status ?? '').toString().toLowerCase();
  const unavailableVariants = ['unavailable', 'unavaliable', 'not_available', 'notavailable'];
  if (service.available === false) return false;
  if (unavailableVariants.includes(status)) return false;
  return true;
};

const OrderManager = () => {
  const [state, dispatch] = useReducer(orderReducer, initialState);
  const [loading, setLoading] = useState(true);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState('');
  const [validationErrors, setValidationErrors] = useState({});
  const [orders, setOrders] = useState([]);
  const { user } = useAuth();

  useEffect(() => {
    console.log('[state change]', {
      selectedServiceIds: state.selectedServiceIds,
      selectedSparePartIds: state.selectedSparePartIds,
      contactPhone: state.contactPhone,
      scheduledDate: state.scheduledDate,
      status: state.status
    });
  }, [state.selectedServiceIds, state.selectedSparePartIds, state.contactPhone, state.scheduledDate, state.status]);

  useEffect(() => {
    let active = true;
    const load = async () => {
      setLoading(true);
      setError('');
      try {
        console.log('[load] fetching services and spare parts...');
        const [servicesRes, partsRes] = await Promise.all([
          axios.get('/api/additional-services'),
          axios.get('/api/spare-parts')
        ]);

        if (!active) return;

        const rawServices = Array.isArray(servicesRes.data) ? servicesRes.data : [];
        const rawParts = Array.isArray(partsRes.data) ? partsRes.data : [];

        const services = normalizeServices(rawServices);
        const spareParts = normalizeParts(rawParts);

        console.log('[load] normalized services sample:', services.slice(0, 5));
        console.log('[load] normalized spareParts sample:', spareParts.slice(0, 5));

        dispatch({ type: 'SET_DATA', payload: { services, spareParts } });
      } catch (err) {
        console.error('[load] Ошибка загрузки данных:', err);
        setError('Ошибка загрузки данных. Попробуйте позже.');
      } finally {
        if (active) setLoading(false);
      }
    };
    load();
    return () => { active = false; };
  }, []);

  useEffect(() => {
    let mounted = true;
    axios.get('/api/orders')
      .then(res => {
        if (mounted && Array.isArray(res.data)) {
          setOrders(res.data);
          console.log('[orders] loaded orders count =', res.data.length);
        }
      })
      .catch(err => {
        console.error('[orders] Ошибка загрузки заказов:', err);
      });
    return () => { mounted = false; };
  }, []);

  const validateForm = () => {
    const errors = {};
    const phonePattern = /^\+375\((29|33|44)\)\d{3}-\d{2}-\d{2}$/;

    if (!state.contactPhone || !state.contactPhone.trim()) {
      errors.contactPhone = 'Телефон обязателен';
    } else if (!phonePattern.test(state.contactPhone.trim())) {
      errors.contactPhone = 'Телефон должен быть в формате +375(29|33|44)###-##-##';
    }

    if (!state.scheduledDate) {
      errors.scheduledDate = 'Дата обязательна';
    }

    if (!Array.isArray(state.selectedServiceIds) || state.selectedServiceIds.length === 0) {
      errors.services = 'Выберите хотя бы одну услугу';
      console.warn('[validate] услуги не выбраны или selectedServiceIds undefined/empty', state.selectedServiceIds);
    } else {
      console.log('[validate] выбранные услуги:', state.selectedServiceIds);
    }

    if (!Array.isArray(state.selectedSparePartIds) || state.selectedSparePartIds.length === 0) {
      errors.spareParts = 'Выберите хотя бы одну запчасть';
      console.warn('[validate] запчасти не выбраны или selectedSparePartIds undefined/empty', state.selectedSparePartIds);
    } else {
      console.log('[validate] выбранные запчасти:', state.selectedSparePartIds);
    }

    setValidationErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('[submit] submit clicked. state snapshot:', {
      selectedServiceIds: state.selectedServiceIds,
      selectedSparePartIds: state.selectedSparePartIds,
      contactPhone: state.contactPhone,
      scheduledDate: state.scheduledDate,
      status: state.status
    });

    if (!validateForm()) {
      console.log('[submit] validation failed, aborting submit');
      return;
    }

    setCreating(true);
    setError('');
    try {
      const servicesTotal = (state.services || [])
        .filter(s => (state.selectedServiceIds || []).includes(String(s._id)))
        .reduce((sum, s) => sum + Number(s.cost?.$numberDecimal ?? s.cost ?? 0), 0);

      const partsTotal = (state.spareParts || [])
        .filter(p => (state.selectedSparePartIds || []).includes(String(p._id)))
        .reduce((sum, p) => sum + Number(p.price?.$numberDecimal ?? p.price ?? 0), 0);

      const total = servicesTotal + partsTotal;

      const body = {
        customer: user?._id,
        services: (state.selectedServiceIds || []).map(id => String(id)),
        spare_parts: (state.selectedSparePartIds || []).map(id => String(id)),
        total_cost: total,
        status: state.status,
        contact_phone: state.contactPhone,
        scheduled_date: state.scheduledDate,
        notes: state.notes
      };

      console.log('[submit] request body:', body);

      const res = await axios.post('/api/orders', body, {
        headers: { Authorization: `Bearer ${localStorage.getItem('authToken')}` }
      });

      console.log('[submit] order created:', res.data);

      const updatedOrders = await axios.get('/api/orders');
      setOrders(Array.isArray(updatedOrders.data) ? updatedOrders.data : []);
      console.log('[submit] orders refreshed, count =', (updatedOrders.data || []).length);

      dispatch({ type: 'RESET' });
      alert('Заказ создан: ' + (res.data?._id ?? 'ID отсутствует'));
    } catch (err) {
      console.error('[submit] Ошибка при создании заказа:', err);
      setError('Ошибка при создании заказа. Попробуйте ещё раз.');
    } finally {
      setCreating(false);
    }
  };

  if (loading) return <p className="loading">Загрузка...</p>;
  if (error) return <p className="error">{error}</p>;

  return (
    <div className="order-manager">
      <h2 className="section-title">Создать заказ</h2>

      <form onSubmit={handleSubmit} className="order-form" noValidate>
        <div className="selector-container">
          <h3>Услуги</h3>
          <ul className="selector-list">
            {(state.services || [])
              .filter(service => {
                const renderable = isServiceRenderable(service);
                if (!renderable) {
                  console.debug('[filter] скрываем услугу (unavailable):', service._id ?? service.id ?? service.name);
                }
                return renderable;
              })
              .map(service => {
                const id = String(service._id);
                const isSelected = (state.selectedServiceIds || []).includes(id);
                return (
                  <li
                    key={id}
                    className={`selector-item ${isSelected ? 'selected' : ''}`}
                    onClick={() => {
                      if (!id) {
                        console.error('[click] service has no id:', service);
                        return;
                      }
                      dispatch({ type: 'TOGGLE_SERVICE', id });
                    }}
                    role="button"
                    tabIndex={0}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        if (!id) {
                          console.error('[keydown] service has no id:', service);
                          return;
                        }
                        dispatch({ type: 'TOGGLE_SERVICE', id });
                      }
                    }}
                  >
                    <div className="selector-main">
                      <strong className="service-name">{service.name}</strong>
                      <span className="service-cost">{service.cost?.$numberDecimal ?? service.cost ?? 0} ₽</span>
                    </div>
                    {isSelected && <span className="selected-badge">Выбрано</span>}
                  </li>
                );
              })}
          </ul>
          {validationErrors.services && <p className="error">{validationErrors.services}</p>}
        </div>

        <div className="selector-container">
          <h3>Запчасти</h3>
          <ul className="selector-list">
            {(state.spareParts || []).map(part => {
              const id = String(part._id);
              const isSelected = (state.selectedSparePartIds || []).includes(id);
              return (
                <li
                  key={id}
                  className={`selector-item ${isSelected ? 'selected' : ''}`}
                  onClick={() => {
                    if (!id) {
                      console.error('[click] part has no id:', part);
                      return;
                    }
                    dispatch({ type: 'TOGGLE_SPARE', id });
                  }}
                  role="button"
                  tabIndex={0}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                      e.preventDefault();
                      if (!id) {
                        console.error('[keydown] part has no id:', part);
                        return;
                      }
                      dispatch({ type: 'TOGGLE_SPARE', id });
                    }
                  }}
                >
                  <div className="selector-main">
                    <strong className="part-name">{part.name}</strong>
                    <span className="part-cost">{part.price?.$numberDecimal ?? part.price ?? 0} ₽</span>
                  </div>
                  {part.manufacturer && <div className="part-manufacturer">{part.manufacturer}</div>}
                </li>
              );
            })}
          </ul>
          {validationErrors.spareParts && <p className="error">{validationErrors.spareParts}</p>}
        </div>

        <div className="form-group">
          <label>Телефон:</label>
          <input
            type="tel"
            placeholder="+375(29)123-45-67"
            value={state.contactPhone}
            onChange={e => dispatch({ type: 'SET_FIELD', field: 'contactPhone', value: e.target.value })}
          />
          {validationErrors.contactPhone && <p className="error">{validationErrors.contactPhone}</p>}
        </div>

        <div className="form-group">
          <label>Дата:</label>
          <input
            type="datetime-local"
            value={state.scheduledDate}
            onChange={e => dispatch({ type: 'SET_FIELD', field: 'scheduledDate', value: e.target.value })}
          />
          {validationErrors.scheduledDate && <p className="error">{validationErrors.scheduledDate}</p>}
        </div>

        <div className="form-group">
          <label>Статус:</label>
          <select
            value={state.status}
            onChange={e => dispatch({ type: 'SET_FIELD', field: 'status', value: e.target.value })}
          >
            <option value="pending">Ожидает</option>
            <option value="confirmed">Подтвержден</option>
            <option value="cancelled">Отменен</option>
            <option value="completed">Завершен</option>
          </select>
        </div>

        <div className="form-group">
          <label>Примечание:</label>
          <textarea
            value={state.notes}
            onChange={e => dispatch({ type: 'SET_FIELD', field: 'notes', value: e.target.value })}
            rows={3}
          />
        </div>

        <button type="submit" className="submit-btn" disabled={creating}>
          {creating ? 'Создание...' : 'Создать заказ'}
        </button>
      </form>

      <h2 className="section-title">Список заказов</h2>
      <div className="orders-grid">
        {orders.length === 0 && <p className="muted">Заказы отсутствуют</p>}
        {orders.map(order => (
          <div key={order._id} className="order-card">
            <div className="order-header">
              <span className="order-customer">{order.customer?.email ?? 'Клиент'}</span>
              <span className={`order-status status-${order.status ?? 'unknown'}`}>{order.status ?? 'unknown'}</span>
            </div>
            <div className="order-body">
              <p><strong>Стоимость:</strong> {order.total_cost?.$numberDecimal ?? order.total_cost ?? 0} ₽</p>
              <p><strong>Дата:</strong> {order.scheduled_date ? new Date(order.scheduled_date).toLocaleString() : '—'}</p>
              <p><strong>Телефон:</strong> {order.contact_phone ?? '—'}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default OrderManager;
