-- ==============================
-- 1. Create Database
-- ==============================
CREATE DATABASE IF NOT EXISTS SpotyFake;
USE SpotyFake;

-- ==============================
-- 2. Reset Tables
-- ==============================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Collaborations;
DROP TABLE IF EXISTS Songs;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Genres;
DROP TABLE IF EXISTS Awards;

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================
-- 3. Create Tables
-- ==============================

-- 3.1 Genres
CREATE TABLE IF NOT EXISTS Genres (
    GenreID TINYINT UNSIGNED AUTO_INCREMENT,
    GenreName VARCHAR(50) NOT NULL,
    SubGenre VARCHAR(50),
    
    CONSTRAINT pkGenres PRIMARY KEY (GenreID),
    CONSTRAINT unqGenreName UNIQUE (GenreName)
) ENGINE=InnoDB;

-- 3.2 Artists
CREATE TABLE IF NOT EXISTS Artists (
    ArtistID INT UNSIGNED AUTO_INCREMENT,
    StageName VARCHAR(100) NOT NULL,
    RealName VARCHAR(150),
    BirthDate DATE,
    PhoneNumber CHAR(15),
    GenreID TINYINT UNSIGNED,
    
    CONSTRAINT pkArtists PRIMARY KEY (ArtistID),
    CONSTRAINT fkArtistsGenre FOREIGN KEY (GenreID)
        REFERENCES Genres(GenreID)
) ENGINE=InnoDB;

-- 3.3 Albums
CREATE TABLE IF NOT EXISTS Albums (
    AlbumID INT UNSIGNED AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    ReleaseYear YEAR,
    ArtistID INT UNSIGNED,
    GenreID TINYINT UNSIGNED,
    Cover BLOB,
    Format SET('CD', 'Vinyl', 'Digital', 'Cassette') NOT NULL DEFAULT 'Digital',

    CONSTRAINT pkAlbums PRIMARY KEY (AlbumID),
    CONSTRAINT fkAlbumGenre FOREIGN KEY (GenreID) REFERENCES Genres(GenreID),
    CONSTRAINT fkAlbumArtist FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
) ENGINE=InnoDB;

-- 3.4 Songs
CREATE TABLE IF NOT EXISTS Songs (
    SongID INT UNSIGNED AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    GenreID TINYINT UNSIGNED,
    ReleaseYear YEAR,
    ArtistID INT UNSIGNED,
    AlbumID INT UNSIGNED,
    AudioFile BLOB,

    CONSTRAINT pkSongs PRIMARY KEY (SongID),
    CONSTRAINT fkSongGenre FOREIGN KEY (GenreID) REFERENCES Genres(GenreID),
    CONSTRAINT fkSongArtist FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    CONSTRAINT fkSongAlbum FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID)
) ENGINE=InnoDB;

-- 3.5 Collaborations (Artist-Song many-to-many)
CREATE TABLE IF NOT EXISTS Collaborations (
    ArtistID INT UNSIGNED,
    SongID INT UNSIGNED,
    Role ENUM('Main', 'Featured') DEFAULT 'Main',

    CONSTRAINT pkArtistSong PRIMARY KEY (ArtistID, SongID),
    CONSTRAINT fkCollabArtist FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID) ON DELETE CASCADE,
    CONSTRAINT fkCollabSong FOREIGN KEY (SongID) REFERENCES Songs(SongID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3.6 Awards 
CREATE TABLE IF NOT EXISTS Awards (
    AwardID INT UNSIGNED AUTO_INCREMENT,
    PrizeName VARCHAR(100) NOT NULL,
    AwardYear YEAR NOT NULL,
    AwardType ENUM('Artist', 'Song', 'Collaboration') NOT NULL,
    ArtistID INT UNSIGNED,
    SongID INT UNSIGNED,
    ExtraInfo JSON,

    CONSTRAINT pkAwards PRIMARY KEY (AwardID),
    CONSTRAINT fkAwardArtist FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    CONSTRAINT fkAwardSong FOREIGN KEY (SongID) REFERENCES Songs(SongID),
    CONSTRAINT chkAwardTarget CHECK (
        (AwardType = 'Artist' AND ArtistID IS NOT NULL AND SongID IS NULL) OR
        (AwardType = 'Song' AND SongID IS NOT NULL AND ArtistID IS NULL) OR
        (AwardType = 'Collaboration' AND ArtistID IS NOT NULL AND SongID IS NOT NULL)
    )
) ENGINE=InnoDB;

-- ==============================
-- 4. Example Inserts
-- ==============================

-- Genres
INSERT INTO Genres (GenreName, SubGenre) VALUES 
('Pop','Dance Pop'),
('Rock','Alternative');

-- Artists
INSERT INTO Artists (StageName, RealName, BirthDate, PhoneNumber, GenreID) VALUES
('Adele','Adele Laurie Blue Adkins','1988-05-05','+441234567890',1),
('Coldplay',NULL,'1997-03-10','+44111222333',2);

-- Albums
INSERT INTO Albums (Title, ReleaseYear, ArtistID, GenreID, Format) VALUES
('25',2015,1,1,'CD,Digital'),
('Parachutes',2000,2,2,'CD,Digital');

-- Songs
INSERT INTO Songs (Title, GenreID, ReleaseYear, ArtistID, AlbumID) VALUES
('Hello',1,2015,1,1),
('Yellow',2,2000,2,2);

-- Collaborations
INSERT INTO Collaborations (ArtistID, SongID, Role) VALUES
(1,1,'Main'),
(2,2,'Main');

-- Awards
INSERT INTO Awards (PrizeName, AwardYear, AwardType, ArtistID, ExtraInfo) VALUES
('Grammy Award',2016,'Artist',1, JSON_OBJECT(
        'Category','Best Pop Vocal Album',
        'Location','Los Angeles',
        'Notes','Awarded for album 25'
    ));

