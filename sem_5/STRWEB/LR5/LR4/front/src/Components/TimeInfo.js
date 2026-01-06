import React, { useEffect, useState } from "react";
import axios from '../axios';

const TimeInfo = () => {
    const [timeInfo, setTimeInfo] = useState(null);
    // const [timezone, setTimezone] = useState(Intl.DateTimeFormat().resolvedOptions().timeZone);

    const timezone= Intl.DateTimeFormat().resolvedOptions().timeZone;

    const offsetInMinutes = new Date().getTimezoneOffset(); // Смещение в минутах
    console.log("Offset in minutes:", offsetInMinutes);

    useEffect(() => {
        fetchTimeInfo();
    }, [timezone]);

    const fetchTimeInfo = async () => {
        try {
            const response = await axios.get("/api/time-info", {
                params: { offsetInMinutes },
            });
            setTimeInfo(response.data);
        } catch (err) {
            console.error("Error fetching time information:", err);
        }
    };

    return (
        <div style={{ padding: "20px", fontFamily: "Arial, sans-serif" }}>
            <h1>Time Information</h1>
            {timeInfo ? (
                <div style={{ border: "1px solid #ccc", padding: "10px", marginTop: "20px" }}>
                    <p>
                        <strong>Your Time:</strong> {timeInfo.userTime}
                    </p>
                    <p>
                        <strong>UTC Time:</strong> {timeInfo.utcTime}
                    </p>
                    <p>
                        <strong>Last Updated (Local):</strong> {timeInfo.lastUpdatedLocal || "No data available"}
                    </p>
                    <p>
                        <strong>Last Updated (UTC):</strong> {timeInfo.lastUpdatedUTC || "No data available"}
                    </p>
                </div>
            ) : (
                <p>Loading...</p>
            )}
        </div>
    );
};

export default TimeInfo;
