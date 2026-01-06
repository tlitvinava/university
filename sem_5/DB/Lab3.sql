CREATE TABLE Role (
    id SERIAL PRIMARY KEY,
    roleName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE "User" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT REFERENCES Role(id) ON DELETE SET NULL,
    dateOfBirth DATE CHECK (dateOfBirth <= CURRENT_DATE - INTERVAL '18 years')
);

CREATE TABLE Car (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE Client (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE,
    orderID INT
);

CREATE TABLE Master (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    orderID INT
);

CREATE TABLE Admin (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE
);

CREATE TABLE Status (
    id SERIAL PRIMARY KEY,
    statusName VARCHAR(50) UNIQUE
);

CREATE TABLE "Order" (
    id SERIAL PRIMARY KEY,
    creationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    clientID INT REFERENCES Client(id) ON DELETE CASCADE,
    carID INT REFERENCES Car(id) ON DELETE CASCADE,
    masterID INT REFERENCES Master(id) ON DELETE SET NULL,
    partID INT,
    serviceID INT,
    status INT UNIQUE REFERENCES Status(id) ON DELETE SET NULL
);

CREATE TABLE Service (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC(10,2) CHECK (price > 0),
    orderID INT REFERENCES "Order"(id) ON DELETE CASCADE
);

CREATE TABLE Part (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC(10,2) CHECK (price > 0),
    orderID INT REFERENCES "Order"(id) ON DELETE CASCADE
);

CREATE TABLE Payment (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(10,2) CHECK (amount > 0),
    paymentMethod VARCHAR(50) NOT NULL,
    orderID INT REFERENCES "Order"(id) ON DELETE CASCADE
);

CREATE TABLE ActionLog (
    id SERIAL PRIMARY KEY,
    userID INT REFERENCES "User"(id) ON DELETE CASCADE
);

CREATE TABLE ClientArchive (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    email VARCHAR(150)
);


ALTER TABLE Client
    ADD CONSTRAINT fk_client_order
    FOREIGN KEY (orderID) REFERENCES "Order"(id);

ALTER TABLE Master
    ADD CONSTRAINT fk_master_order
    FOREIGN KEY (orderID) REFERENCES "Order"(id);

ALTER TABLE ActionLog ADD COLUMN action_timestamp TIMESTAMP DEFAULT NOW();

CREATE TABLE test_db.ActionLog (
    id SERIAL PRIMARY KEY,
    userID INT REFERENCES test_db."User"(id) ON DELETE CASCADE,
    action TEXT,
    action_timestamp TIMESTAMP DEFAULT NOW(),
    table_name VARCHAR(100),
  	operation VARCHAR(10),
    row_id INT,
    row_data JSONB
);

ALTER TABLE ActionLog
  ADD COLUMN table_name VARCHAR(100),
  ADD COLUMN operation VARCHAR(10),
  ADD COLUMN row_id INT,
  ADD COLUMN row_data JSONB;


commit

drop table "Order" CASCADE;
drop table "User" CASCADE;
drop table "admin" CASCADE;
drop table "actionlog" CASCADE;
drop table "car" CASCADE;
drop table "client" CASCADE;
drop table "master" CASCADE;
drop table "part" CASCADE;
drop table "payment" CASCADE;
drop table "role" CASCADE;
drop table "service" CASCADE;
drop table "status" CASCADE;

CREATE TABLE django_migrations (
    id serial PRIMARY KEY,
    app varchar(255) NOT NULL,
    name varchar(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);

SELECT * FROM django_migrations ORDER BY applied;
