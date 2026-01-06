// import React, { useState } from 'react';
// import axios from '../axios';
// import { useNavigate } from 'react-router-dom';
// import './Styles/AddService.css';

// const AddService = () => {
//     const [name, setName] = useState('');
//     const [description, setDescription] = useState('');
//     const [cost, setCost] = useState('');
//     const [available, setAvailable] = useState(true);
//     const [duration, setDuration] = useState('');

//     const navigate = useNavigate();

//     const handleSubmit = (e) => {
//         e.preventDefault();
//         const newService = { name, description, cost, available, duration_minutes: duration };

//         axios.post('/api/additional-services', newService)
//             .then(() => {
//                 navigate('/');
//             })
//             .catch(error => console.error('Error adding service:', error));
//     };

//     return (
//         <div className="add-service-container">
//             <h2>Add New Service</h2>
//             <form onSubmit={handleSubmit}>
//                 <div>
//                     <label>Name:</label>
//                     <input type="text" value={name} onChange={(e) => setName(e.target.value)} required />
//                 </div>
//                 <div>
//                     <label>Description:</label>
//                     <textarea value={description} onChange={(e) => setDescription(e.target.value)} required />
//                 </div>
//                 <div>
//                     <label>Cost:</label>
//                     <input type="number" value={cost} onChange={(e) => setCost(e.target.value)} required />
//                 </div>
//                 <div>
//                     <label>Available:</label>
//                     <input type="checkbox" checked={available} onChange={(e) => setAvailable(e.target.checked)} />
//                 </div>
//                 <div>
//                     <label>Duration (in minutes):</label>
//                     <input type="number" value={duration} onChange={(e) => setDuration(e.target.value)} required />
//                 </div>
//                 <button type="submit">Add Service</button>
//             </form>
//         </div>
//     );
// };

// export default AddService;


import React, { useState } from 'react';
import axios from '../axios';
import { useNavigate } from 'react-router-dom';
import './Styles/AddService.css';

const AddService = () => {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [cost, setCost] = useState('');
  const [available, setAvailable] = useState(true);
  const [duration, setDuration] = useState('');

  const [errors, setErrors] = useState({
    name: '',
    description: '',
    cost: '',
    duration: '',
    submit: ''
  });

  const navigate = useNavigate();

  const validate = () => {
    const next = { name: '', description: '', cost: '', duration: '', submit: '' };
    let valid = true;

    if (!name.trim()) {
      next.name = 'Название обязательно';
      valid = false;
    }
    if (!description.trim()) {
      next.description = 'Описание обязательно';
      valid = false;
    }

    const costNum = Number(cost);
    if (cost === '') {
      next.cost = 'Стоимость обязательна';
      valid = false;
    } else if (Number.isNaN(costNum)) {
      next.cost = 'Стоимость должна быть числом';
      valid = false;
    } else if (costNum < 0) {
      next.cost = 'Стоимость не может быть отрицательной';
      valid = false;
    }

    const durationNum = Number(duration);
    if (duration === '') {
      next.duration = 'Длительность обязательна';
      valid = false;
    } else if (!Number.isInteger(durationNum)) {
      next.duration = 'Длительность должна быть целым числом (минуты)';
      valid = false;
    } else if (durationNum < 0) {
      next.duration = 'Длительность не может быть отрицательной';
      valid = false;
    }

    setErrors(next);
    return { valid, costNum, durationNum };
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    const { valid, costNum, durationNum } = validate();
    if (!valid) {
      setErrors((prev) => ({ ...prev, submit: 'Пожалуйста, исправьте ошибки в форме' }));
      return;
    }

    const newService = {
      name: name.trim(),
      description: description.trim(),
      cost: costNum,
      available,
      duration_minutes: durationNum
    };

    axios.post('/api/additional-services', newService)
      .then(() => {
        navigate('/');
      })
      .catch((error) => {
        console.error('Error adding service:', error);
        setErrors((prev) => ({ ...prev, submit: 'Ошибка при добавлении сервиса. Попробуйте позже.' }));
      });
  };

  return (
    <div className="add-service-container">
      <h2>Add New Service</h2>

      <form onSubmit={handleSubmit} noValidate>
        <div className="form-row">
          <label htmlFor="service-name">Name:</label>
          <input
            id="service-name"
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            aria-invalid={!!errors.name}
            aria-describedby={errors.name ? 'error-name' : undefined}
            required
          />
          {errors.name && (
            <div id="error-name" className="field-error" role="alert">
              {errors.name}
            </div>
          )}
        </div>

        <div className="form-row">
          <label htmlFor="service-description">Description:</label>
          <textarea
            id="service-description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            aria-invalid={!!errors.description}
            aria-describedby={errors.description ? 'error-description' : undefined}
            required
          />
          {errors.description && (
            <div id="error-description" className="field-error" role="alert">
              {errors.description}
            </div>
          )}
        </div>

        <div className="form-row">
          <label htmlFor="service-cost">Cost:</label>
          <input
            id="service-cost"
            type="number"
            value={cost}
            onChange={(e) => setCost(e.target.value)}
            aria-invalid={!!errors.cost}
            aria-describedby={errors.cost ? 'error-cost' : undefined}
            min="0"
            step="0.01"
            required
          />
          {errors.cost && (
            <div id="error-cost" className="field-error" role="alert">
              {errors.cost}
            </div>
          )}
        </div>

        <div className="form-row">
          <label htmlFor="service-available">Available:</label>
          <input
            id="service-available"
            type="checkbox"
            checked={available}
            onChange={(e) => setAvailable(e.target.checked)}
          />
        </div>

        <div className="form-row">
          <label htmlFor="service-duration">Duration (in minutes):</label>
          <input
            id="service-duration"
            type="number"
            value={duration}
            onChange={(e) => setDuration(e.target.value)}
            aria-invalid={!!errors.duration}
            aria-describedby={errors.duration ? 'error-duration' : undefined}
            min="0"
            step="1"
            required
          />
          {errors.duration && (
            <div id="error-duration" className="field-error" role="alert">
              {errors.duration}
            </div>
          )}
        </div>

        <div className="form-actions">
          <button type="submit">Add Service</button>
        </div>

        {errors.submit && (
          <div className="form-error" role="alert" aria-live="assertive">
            {errors.submit}
          </div>
        )}
      </form>
    </div>
  );
};

export default AddService;
