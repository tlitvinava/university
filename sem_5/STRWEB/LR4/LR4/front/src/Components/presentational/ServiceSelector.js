// src/components/presentational/ServiceSelector.js
import React, { useState } from 'react';

const ServiceSelector = ({
  items = [],
  selectedIds = [],
  onToggle = () => {},
  onChangeSearch = () => {}
}) => {
  const [search, setSearch] = useState('');

  const filtered = items.filter(s =>
    s.name.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="service-card">
      <h2>Services</h2>
      <input
        type="text"
        placeholder="Search services..."
        value={search}
        onChange={(e) => { setSearch(e.target.value); onChangeSearch(e.target.value); }} // onChange
      />
      <ul>
        {filtered.map(s => (
          <li key={s.id || s._id}>
            <label>
              <input
                type="checkbox"
                checked={selectedIds.includes(s.id || s._id)}
                onChange={() => onToggle(s.id || s._id)} // onChange
              />
              {s.name} — {s.cost?.$numberDecimal ?? s.price ?? s.cost}
            </label>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ServiceSelector;
