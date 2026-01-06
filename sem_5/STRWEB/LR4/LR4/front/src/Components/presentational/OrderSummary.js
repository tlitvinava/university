// src/components/presentational/OrderSummary.js
import React, { useMemo } from 'react';

const OrderSummary = ({
  services = [],
  spareParts = [],
  selectedServiceIds = [],
  selectedSparePartIds = []
}) => {
  const toNumber = (x) => {
    if (!x) return 0;
    if (typeof x === 'string') return parseFloat(x);
    if (x.$numberDecimal) return parseFloat(x.$numberDecimal);
    return Number(x);
  };

  const sum = useMemo(() => {
    const serviceMap = new Map(services.map(s => [s.id || s._id, toNumber(s.cost?.$numberDecimal ?? s.price ?? s.cost)]));
    const partMap = new Map(spareParts.map(p => [p.id || p._id, toNumber(p.price?.$numberDecimal ?? p.price)]));
    const servicesTotal = selectedServiceIds.reduce((acc, id) => acc + (serviceMap.get(id) || 0), 0);
    const partsTotal = selectedSparePartIds.reduce((acc, id) => acc + (partMap.get(id) || 0), 0);
    return { servicesTotal, partsTotal, total: servicesTotal + partsTotal };
  }, [services, spareParts, selectedServiceIds, selectedSparePartIds]);

  return (
    <div className="order-details">
      <p><strong>Services:</strong> ${sum.servicesTotal.toFixed(2)}</p>
      <p><strong>Spare parts:</strong> ${sum.partsTotal.toFixed(2)}</p>
      <p><strong>Total:</strong> ${sum.total.toFixed(2)}</p>
    </div>
  );
};

export default OrderSummary;
