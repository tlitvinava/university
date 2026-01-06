// Modal.js
import React, { useEffect, useRef } from 'react';

const Modal = ({ part, onClose }) => {
  const modalRef = useRef(null);

  useEffect(() => {
    const onKeyDown = (e) => {
      if (e.key === 'Escape') onClose();
    };
    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, [onClose]);

  return (
    <div className="modal-backdrop" onMouseDown={(e) => e.target === e.currentTarget && onClose()}>
      <div className="modal" ref={modalRef} role="dialog" aria-modal="true">
        <div className="modal-header">
          <h3>{part.name}</h3>
          <button onClick={onClose}>✕</button>
        </div>
        <div className="modal-body">
          <p>{part.description || 'Описание отсутствует'}</p>
        </div>
        <div className="modal-footer">
          <button onClick={onClose}>Закрыть</button>
        </div>
      </div>
    </div>
  );
};

export default Modal;
