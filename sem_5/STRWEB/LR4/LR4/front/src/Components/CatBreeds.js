// import React from "react";
import "./Styles/CatBreeds.css";
import axios from "../axios";
import React, { useState, useEffect } from "react";

const CatBreedCard = ({ breed }) => {
    return (
        <div className="cat-card">
            <h2 className="cat-name">{breed.name}</h2>
            <p className="cat-description">{breed.description}</p>
            <p><strong>Origin:</strong> {breed.origin}</p>
            <p><strong>Temperament:</strong> {breed.temperament}</p>
            <p><strong>Life Span:</strong> {breed.life_span} years</p>
            <p><strong>Weight:</strong> {breed.weight.metric} kg</p>
            <div className="cat-links">
                <a href={breed.wikipedia_url} target="_blank" rel="noopener noreferrer">Wikipedia</a>
                <a href={breed.cfa_url} target="_blank" rel="noopener noreferrer">CFA</a>
                <a href={breed.vetstreet_url} target="_blank" rel="noopener noreferrer">VetStreet</a>
            </div>
        </div>
    );
};

const CatBreedsList = () => {
    const [breedsList, setBreedsList] = useState([]); 
    const [isLoading, setIsLoading] = useState(true); 
    const [error, setError] = useState(null); 

    useEffect(() => {
        const fetchBreeds = async () => {
            try {
                const response = await axios.get("/api/cat_breeds"); 
                setBreedsList(response.data); 
                setIsLoading(false); 
            } catch (err) {
                setError("Failed to fetch cat breeds.");
                setIsLoading(false);
            }
        };

        fetchBreeds(); 
    }, []); 

    if (isLoading) {
        return <p>Loading...</p>;
    }

    if (error) {
        return <p>{error}</p>;
    }

    return (
        <div className="cat-breeds-container">
            {breedsList.map((breed) => (
                <CatBreedCard key={breed.id} breed={breed} />
            ))}
        </div>
    );
};

export default CatBreedsList;
