-- ==============================
-- 2.1 CREATE DATABASE
-- ==============================

CREATE DATABASE spotifake;

-- ==============================
-- 2.2 DROP DATABASE
-- ==============================

USE Spotifake;
DROP spotyfake;

-- ==============================
-- 2.3. CREATE TABLE
-- ==============================

CREATE TABLE albumns (AlbumID int, Title varchar(255), YearRelease year, Artist VARCHAR(255), GenreID int , Cover blob);
show tables;
CREATE TABLE IF NOT EXISTS Artists (ArtistID INT UNSIGNED AUTO_INCREMENT,StageName VARCHAR(100) NOT NULL,RealName VARCHAR(150), BirthDate DATE,
PhoneNumber CHAR(15),GenreID TINYINT UNSIGNED,Nacionality ENUM('ES', 'AR', 'MX','CL','CO','US','OTHER') DEFAULT 'OTHER');
CREATE TABLE SocialMediaAccounts (ProfileName varchar (255), Mastodon boolean, Peertube boolean, PixelFed boolean);
DESCRIBE Albums;
DESCRIBE SocialMediaAccounts;

-- ==============================
-- 2.4. DROP TABLE
-- ==============================

DROP TABLE SocialMediaAccounts;
SHOW TABLES;

-- ==============================
-- 2.5. ALTER TABLE
-- ==============================

ALTER TABLE Albums ADD COLUMN Laber VARCHAR(100) AFTER Artist;
DESCRIBE Albums;
ALTER TABLE Albums DROP COLUMN Label;
-- 2.6.CONSTRAINTS
ALTER TABLE genres ADD PRIMARY KEY (GenreID);
ALTER TABLE albums ADD CONSTRAINT fk_AlbumGenre FOREIGN KEY (GenreID) REFERENCES Genres(GenreID);

-- ==============================
-- 2.7. NOT NULL
-- ==============================

ALTER TABLE MODIFY COLUMN StageName VARCHAR (100) NOT NULL;

-- ==============================
-- 2.8. UNIQUE
-- ==============================

DESCRIBE Albums;
ALTER TABLE Albums ADD PRIMARY KEY (AlbumID);

-- ==============================
-- 2.13.CREATE INDEX
-- ==============================

CREATE INDEX idx_artistsName ON Artists (StageName);
SHOW INDEX FROM Artists;

-- ==============================
-- 2.14. AUTO INCREMENT
-- ==============================

ALTER TABLE Albums MODIFY AlbumID INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Albums AUTO_INCREMENT=1000;
-- 2.15. DATES
ALTER TABLE Albums ADD CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP;

-- ==============================
-- 2.16. VIEWS
-- ==============================

CREATE VIEW artistBDAY AS SELECT RealName, PhoneNumber FROM Artists;
ALTER VIEW ArtistBDAY AS SELECT RealName, PhoneNumber, BirthDate FROM Artists;
DROP VIEW ArtistBDAY;
