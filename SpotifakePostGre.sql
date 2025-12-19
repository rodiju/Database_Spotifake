-- ==============================
-- 4.1. Create Database
-- ==============================

CREATE DATABASE spotifake;

\c spotifake


-- ==============================
-- 4.2. Reset Tables
-- ==============================

DROP TABLE IF EXISTS collaborations CASCADE;
DROP TABLE IF EXISTS songs CASCADE;
DROP TABLE IF EXISTS albums CASCADE;
DROP TABLE IF EXISTS awards CASCADE;
DROP TABLE IF EXISTS artists CASCADE;
DROP TABLE IF EXISTS genres CASCADE;

DROP TYPE IF EXISTS nationality_enum;
DROP TYPE IF EXISTS award_type_enum;
DROP TYPE IF EXISTS collaboration_role_enum;


-- ==============================
-- 4.3. Custom Types (ENUMs)
-- ==============================

CREATE TYPE nationality_enum AS ENUM (
    'ES', 'AR', 'MX', 'CL', 'CO', 'US', 'OTHER'
);

CREATE TYPE award_type_enum AS ENUM (
    'Artist', 'Song', 'Collaboration'
);

CREATE TYPE collaboration_role_enum AS ENUM (
    'Main', 'Featured'
);


-- ==============================
-- 4.3. Create Tables
-- ==============================

-- 4.3.1 Genres
CREATE TABLE genres (
    genre_id SMALLSERIAL,
    genre_name VARCHAR(50) NOT NULL,
    sub_genre VARCHAR(50),

    CONSTRAINT pk_genres PRIMARY KEY (genre_id),
    CONSTRAINT unq_genre_name UNIQUE (genre_name)
);


-- 5.4.2 Artists
CREATE TABLE artists (
    artist_id SERIAL,
    stage_name VARCHAR(100) NOT NULL,
    real_name VARCHAR(150),
    birth_date DATE,
    phone_number CHAR(15),
    genre_id SMALLINT,
    nationality nationality_enum DEFAULT 'OTHER',

    CONSTRAINT pk_artists PRIMARY KEY (artist_id),
    CONSTRAINT fk_artists_genre
        FOREIGN KEY (genre_id)
        REFERENCES genres (genre_id)
);


-- 5.4.3 Albums
CREATE TABLE albums (
    album_id SERIAL,
    title VARCHAR(150) NOT NULL,
    release_year INTEGER,
    artist_id INTEGER,
    genre_id SMALLINT,
    cover BYTEA,
    format TEXT[] NOT NULL DEFAULT ARRAY['Digital'],

    CONSTRAINT pk_albums PRIMARY KEY (album_id),
    CONSTRAINT fk_album_artist
        FOREIGN KEY (artist_id)
        REFERENCES artists (artist_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_album_genre
        FOREIGN KEY (genre_id)
        REFERENCES genres (genre_id),
    CONSTRAINT chk_album_year
        CHECK (release_year BETWEEN 1900 AND 2100)
);


-- 4.4 Songs
CREATE TABLE songs (
    song_id SERIAL,
    title VARCHAR(150) NOT NULL,
    genre_id SMALLINT,
    release_year INTEGER,
    artist_id INTEGER,
    album_id INTEGER,
    audio_file BYTEA,

    CONSTRAINT pk_songs PRIMARY KEY (song_id),
    CONSTRAINT fk_song_genre
        FOREIGN KEY (genre_id)
        REFERENCES genres (genre_id),
    CONSTRAINT fk_song_artist
        FOREIGN KEY (artist_id)
        REFERENCES artists (artist_id),
    CONSTRAINT fk_song_album
        FOREIGN KEY (album_id)
        REFERENCES albums (album_id)
);


-- 4.5 Collaborations 
CREATE TABLE collaborations (
    artist_id INTEGER,
    song_id INTEGER,
    role collaboration_role_enum DEFAULT 'Main',

    CONSTRAINT pk_collaborations PRIMARY KEY (artist_id, song_id),
    CONSTRAINT fk_collab_artist
        FOREIGN KEY (artist_id)
        REFERENCES artists (artist_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_collab_song
        FOREIGN KEY (song_id)
        REFERENCES songs (song_id)
        ON DELETE CASCADE
);


-- 4.6 Awards
CREATE TABLE awards (
    award_id SERIAL,
    prize_name VARCHAR(100) NOT NULL,
    award_year INTEGER NOT NULL,
    award_type award_type_enum NOT NULL,
    artist_id INTEGER,
    song_id INTEGER,
    extra_info JSONB,

    CONSTRAINT pk_awards PRIMARY KEY (award_id),
    CONSTRAINT fk_award_artist
        FOREIGN KEY (artist_id)
        REFERENCES artists (artist_id),
    CONSTRAINT fk_award_song
        FOREIGN KEY (song_id)
        REFERENCES songs (song_id),
    CONSTRAINT chk_award_target CHECK (
        (award_type = 'Artist' AND artist_id IS NOT NULL AND song_id IS NULL) OR
        (award_type = 'Song' AND song_id IS NOT NULL AND artist_id IS NULL) OR
        (award_type = 'Collaboration' AND artist_id IS NOT NULL AND song_id IS NOT NULL)
    )
);


-- ==============================
-- 5. Example Inserts
-- ==============================

-- Genres
INSERT INTO genres (genre_name, sub_genre) VALUES
('Pop', 'Dance Pop'),
('Rock', 'Alternative');

-- Artists
INSERT INTO artists (stage_name, real_name, birth_date, phone_number, genre_id)
VALUES
('Adele', 'Adele Laurie Blue Adkins', '1988-05-05', '+441234567890', 1),
('Coldplay', NULL, '1997-03-10', '+44111222333', 2);

-- Albums
INSERT INTO albums (title, release_year, artist_id, genre_id, format)
VALUES
('25', 2015, 1, 1, ARRAY['CD','Digital']),
('Parachutes', 2000, 2, 2, ARRAY['CD','Digital']);

-- Songs
INSERT INTO songs (title, genre_id, release_year, artist_id, album_id)
VALUES
('Hello', 1, 2015, 1, 1),
('Yellow', 2, 2000, 2, 2);

-- Collaborations
INSERT INTO collaborations (artist_id, song_id, role)
VALUES
(1, 1, 'Main'),
(2, 2, 'Main');

-- Awards
INSERT INTO awards (prize_name, award_year, award_type, artist_id, extra_info)
VALUES (
    'Grammy Award',
    2016,
    'Artist',
    1,
    jsonb_build_object(
        'category', 'Best Pop Vocal Album',
        'location', 'Los Angeles',
        'notes', 'Awarded for album 25'
    )
);
