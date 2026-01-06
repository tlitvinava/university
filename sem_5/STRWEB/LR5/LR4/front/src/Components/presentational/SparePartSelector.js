// src/components/presentational/SparePartSelector.js
import React from 'react';

const SparePartSelector = ({
  items = [],
  selectedIds = [],
  onToggle = () => {}
}) => {
  return (
    <div className="spare-part-card">
      <h2>Spare parts</h2>
      <ul>
        {items.map(p => (
          <li key={p.id || p._id}>
            <button
              type="button"
              className={selectedIds.includes(p.id || p._id) ? 'selected' : ''}
              onClick={() => onToggle(p.id || p._id)} // onClick
            >
              {p.name} — {p.price?.$numberDecimal ?? p.price}
              {p.manufacturer ? ` (${p.manufacturer})` : ''}
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
};

SparePartSelector.defaultProps = {
  items: [],
  selectedIds: [],
  onToggle: () => {}
};

export default SparePartSelector;
