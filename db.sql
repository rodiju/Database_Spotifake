CREATE DATABASE IF NOT EXISTS Spotyfake;
USE Spotyfake;

-- 🔹 Drop tables if exist(for reset)
DROP TABLE IF EXISTS Awards;
-- 🔹 Create table
CREATE TABLE IF NOT EXISTS Awards(
    AwardsID int UNSIGNED PRIMARY KEY auto_increment,
    AwardsName VARCHAR(255) NOT NULL,
    Years YEAR NOT NULL
);
-- UNSIGNED EVITA NUMEROS NEGATIVOS
-- YEAR

CREATE TABLE IF NOT EXISTS Genres(
    GenresID int PRIMARY KEY auto_increment,
    Genre VARCHAR(255) NOT NULL,
    Subgenre VARCHAR(255)
)
CREATE TABLE 