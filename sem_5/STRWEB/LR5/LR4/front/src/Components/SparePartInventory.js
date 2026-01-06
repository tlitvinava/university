// src/components/SparePartInventory.js
import React from 'react';
import axios from '../axios';

class SparePartInventory extends React.Component {
  state = {
    parts: [],
    search: '',
    name: '',
    price: '',
    manufacturer: '',
    in_stock: true,
    quantity_available: 0,
    loading: false,
    error: ''
  };

  componentDidMount() {
    this.loadParts();
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.search !== this.state.search) {
      // Live filter side-effect (no API call, just local)
    }
  }

  componentWillUnmount() {
    // Cleanups if needed (e.g., cancel tokens)
  }

  loadParts = async () => {
    this.setState({ loading: true, error: '' });
    try {
      const res = await axios.get('/api/spare-parts');
      this.setState({ parts: res.data });
    } catch (e) {
      this.setState({ error: 'Failed to load spare parts' });
    } finally {
      this.setState({ loading: false });
    }
  };

  handleField = (e) => this.setState({ [e.target.name]: e.target.value }); // onChange
  handleToggleStock = () => this.setState({ in_stock: !this.state.in_stock }); // onClick

  handleSubmit = async (e) => {
    e.preventDefault();
    const body = {
      name: this.state.name,
      price: this.state.price,
      manufacturer: this.state.manufacturer,
      in_stock: this.state.in_stock,
      quantity_available: Number(this.state.quantity_available)
    };
    try {
      await axios.post('/api/spare-parts', body);
      await this.loadParts();
      this.setState({ name: '', price: '', manufacturer: '', quantity_available: 0, in_stock: true });
    } catch (e) {
      this.setState({ error: 'Failed to create spare part' });
    }
  };

  handleDelete = async (id) => {
    try {
      await axios.delete(`/api/spare-parts/${id}`);
      await this.loadParts();
    } catch (e) {
      this.setState({ error: 'Failed to delete spare part' });
    }
  };

  render() {
    const { parts, search, name, price, manufacturer, in_stock, quantity_available, loading, error } = this.state;
    const filtered = parts.filter(p =>
      p.name.toLowerCase().includes(search.toLowerCase()) ||
      (p.manufacturer || '').toLowerCase().includes(search.toLowerCase())
    );

    return (
      <div className="spare-part-list-container">
        <h2>Spare Parts Inventory</h2>

        {error && <p style={{ color: 'red' }}>{error}</p>}

        <div className="controls">
          <input
            type="text"
            name="search"
            placeholder="Search spare parts..."
            value={search}
            onChange={this.handleField} // onChange
          />
        </div>

        <form onSubmit={this.handleSubmit}> {/* onSubmit */}
          <div className="spare-part-card">
            <input
              type="text"
              name="name"
              placeholder="Name"
              value={name}
              onChange={this.handleField} // onChange
            />
            <input
              type="number"
              name="price"
              placeholder="Price"
              value={price}
              onChange={this.handleField} // onChange
            />
            <input
              type="text"
              name="manufacturer"
              placeholder="Manufacturer"
              value={manufacturer}
              onChange={this.handleField} // onChange
            />
            <input
              type="number"
              name="quantity_available"
              placeholder="Quantity"
              value={quantity_available}
              onChange={this.handleField} // onChange
            />
            <label>
              <input
                type="checkbox"
                checked={in_stock}
                onChange={this.handleToggleStock} // onChange (checkbox) + handler toggles
              />
              In stock
            </label>
            <button type="submit" onClick={() => console.log('Create part')}>Create</button> {/* onClick */}
          </div>
        </form>

        {loading ? <p>Loading...</p> : (
          <ul className="spare-part-list">
            {filtered.map(p => (
              <li key={p._id} className="spare-part-item">
                <div>
                  <strong>{p.name}</strong> — {p.price?.$numberDecimal ?? p.price} {p.manufacturer ? `(${p.manufacturer})` : ''}
                </div>
                <div>
                  <span>{p.in_stock ? 'In stock' : 'Out of stock'}</span> | <span>Qty: {p.quantity_available}</span>
                </div>
                <button onClick={() => this.handleDelete(p._id)}>Delete</button> {/* onClick */}
              </li>
            ))}
          </ul>
        )}
      </div>
    );
  }
}

export default SparePartInventory;
