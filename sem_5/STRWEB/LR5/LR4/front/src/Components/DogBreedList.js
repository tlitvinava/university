import React, { useState, useEffect } from "react";
import axios from "../axios";
import "./Styles/DogBreedList.css";

const DogBreedCard = ({ breed }) => {
    return (
        <div className="dog-breed-card">
            <h2>{breed.name}</h2>
            <p><strong>Bred for:</strong> {breed.bred_for || "Unknown"}</p>
            <p><strong>Breed group:</strong> {breed.breed_group || "Unknown"}</p>
            <p><strong>Life span:</strong> {breed.life_span}</p>
            <p><strong>Temperament:</strong> {breed.temperament}</p>
            <p><strong>Origin:</strong> {breed.origin || "Unknown"}</p>
            <div className="dog-breed-stats">
                <p><strong>Weight:</strong> {breed.weight.metric} kg</p>
                <p><strong>Height:</strong> {breed.height.metric} cm</p>
            </div>
            {breed.reference_image_id && (
                <img
                    className="dog-breed-image"
                    src={`https://cdn2.thedogapi.com/images/${breed.reference_image_id}.jpg`}
                    alt={breed.name}
                />
            )}
        </div>
    );
};

const DogBreedsList = () => {
    const [breedsList, setBreedsList] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchBreeds = async () => {
            try {
                const response = await axios.get("/api/dog_breeds");
                setBreedsList(response.data);
                setIsLoading(false);
            } catch (err) {
                setError("Failed to fetch dog breeds.");
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
        <div className="dog-breeds-container">
            {breedsList.map((breed) => (
                <DogBreedCard key={breed.id} breed={breed} />
            ))}
        </div>
    );
};

export default DogBreedsList;
