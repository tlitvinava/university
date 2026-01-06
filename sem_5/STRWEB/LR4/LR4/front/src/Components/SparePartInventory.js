import React, { useState, useEffect, useRef } from 'react';
import axios from '../axios';
import './Styles/SparePartList.css';

const SparePartInventory = () => {
  const [parts, setParts] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [activePart, setActivePart] = useState(null); 
  const lastFocusedRef = useRef(null); 
  const modalRef = useRef(null);

  const getId = (p) => p?._id ?? p?.id;

  useEffect(() => {
    fetchParts();
    
  }, [searchQuery]);

  const fetchParts = () => {
    setLoading(true);
    setError('');
    axios
      .get('/api/spare-parts', { params: { search: searchQuery } })
      .then((res) => {
        setParts(Array.isArray(res.data) ? res.data : []);
      })
      .catch(() => setError('Failed to load spare parts'))
      .finally(() => setLoading(false));
  };

  const filtered = parts.filter(
    (p) =>
      (p.name || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
      (p.manufacturer || '').toLowerCase().includes(searchQuery.toLowerCase())
  );

  const openModal = (part, eventTarget) => {
    lastFocusedRef.current = eventTarget || document.activeElement;
    setActivePart(part);
  };

  const closeModal = () => {
    setActivePart(null);
    if (lastFocusedRef.current && typeof lastFocusedRef.current.focus === 'function') {
      lastFocusedRef.current.focus();
    }
  };

  useEffect(() => {
    if (!activePart) return;

    const onKeyDown = (e) => {
      if (e.key === 'Escape') {
        e.preventDefault();
        closeModal();
      }
      if (e.key === 'Tab' && modalRef.current) {
        const focusable = modalRef.current.querySelectorAll(
          'a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])'
        );
        if (focusable.length === 0) {
          e.preventDefault();
          return;
        }
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (e.shiftKey && document.activeElement === first) {
          e.preventDefault();
          last.focus();
        } else if (!e.shiftKey && document.activeElement === last) {
          e.preventDefault();
          first.focus();
        }
      }
    };

    document.addEventListener('keydown', onKeyDown);
    const timer = setTimeout(() => {
      const focusable = modalRef.current?.querySelectorAll(
        'a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])'
      );
      if (focusable && focusable.length > 0) {
        focusable[0].focus();
      } else if (modalRef.current) {
        modalRef.current.focus();
      }
    }, 0);

    return () => {
      clearTimeout(timer);
      document.removeEventListener('keydown', onKeyDown);
    };
  }, [activePart]);

  return (
    <div className="service-list-container">
      <h2>Spare Parts Inventory</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}

      <div className="controls">
        <input
          type="text"
          placeholder="Search spare parts..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="search-input"
          aria-label="Search spare parts"
        />
      </div>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <ul className="service-list" aria-live="polite">
          {filtered.map((p) => {
            const id = getId(p) ?? `tmp-${Math.random().toString(36).slice(2, 9)}`;
            const imageUrl = p.image || '/images/default-part.png'; 
            return (
              <li key={id} className="service-item">
                <div className="service-thumb">
                  <img
                    src={imageUrl}
                    alt={p.name}
                    className="service-image"
                    onError={(e) => {
                      e.target.onerror = null;
                      e.target.src = '/images/default-part.png';
                    }}
                  />
                </div>

                <div className="service-info">
                  <strong className="service-name">{p.name}</strong>
                  <p className="service-description">Manufacturer: {p.manufacturer || 'Unknown'}</p>
                  <p className="service-description">Price: {p.price?.$numberDecimal ?? p.price}</p>
                  <p className="service-description">Quantity: {p.quantity_available ?? '—'}</p>
                  <p className="service-description">Status: {p.in_stock ? '✅ In stock' : '❌ Out of stock'}</p>

                  <div className="service-actions">
                    <button
                      type="button"
                      className="details-btn"
                      onDoubleClick={(e) => openModal(p, e.currentTarget)}
                      aria-haspopup="dialog"
                      aria-controls={`part-modal-${id}`}
                    >
                      Подробнее
                    </button>
                  </div>
                </div>
              </li>
            );
          })}
        </ul>
      )}

      {parts.length === 0 && !loading && <p>No spare parts found.</p>}

      {/* Модальное окно */}
      {activePart && (
        <div
          className="modal-backdrop"
          role="presentation"
          onMouseDown={(e) => {
            if (e.target === e.currentTarget) closeModal();
          }}
        >
          <div
            id={`part-modal-${getId(activePart) ?? 'active'}`}
            className="modal"
            role="dialog"
            aria-modal="true"
            aria-label={`Описание ${activePart.name}`}
            ref={modalRef}
            tabIndex={-1}
          >
            <div className="modal-header">
              <h3 className="modal-title">{activePart.name}</h3>
              <button
                type="button"
                className="modal-close"
                aria-label="Close"
                onClick={closeModal}
              >
                ✕
              </button>
            </div>

            <div className="modal-body">
              <div className="modal-thumb">
                <img
                  src={activePart.image || '/images/default-part.png'}
                  alt={activePart.name}
                  onError={(e) => {
                    e.target.onerror = null;
                    e.target.src = '/images/default-part.png';
                  }}
                />
              </div>

              <div className="modal-info">
                <p><strong>Описание:</strong></p>
                <p>{activePart.description || 'Описание отсутствует'}</p>

                <p><strong>Производитель:</strong> {activePart.manufacturer || 'Unknown'}</p>
                <p><strong>Количество:</strong> {activePart.quantity_available ?? '—'}</p>
                <p><strong>Цена:</strong> {activePart.price?.$numberDecimal ?? activePart.price ?? '—'} ₽</p>
                <p><strong>Статус:</strong> {activePart.in_stock ? '✅ В наличии' : '❌ Нет в наличии'}</p>
              </div>
            </div>

            <div className="modal-footer">
              <button type="button" className="btn-secondary" onClick={closeModal}>
                Закрыть
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default SparePartInventory;
