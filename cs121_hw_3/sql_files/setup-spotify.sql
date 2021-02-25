-- [Problem 1]
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS artist, album, playlist;

-- Artist is a table of artists. Artist uri is a unique identifier for each
-- artist. Name is the name of the artist.

CREATE TABLE artist(
artist_uri VARCHAR(250) PRIMARY KEY, 
artist_name VARCHAR(250) NOT NULL
);

-- Album table is a table of albums. Album uri is a unique identifier for each
-- album. Name is the name. Release date is the date the album was released

CREATE TABLE album(
album_uri VARCHAR(250) PRIMARY KEY,
album_name VARCHAR(250) NOT NULL, 
release_date DATE NOT NULL
);

-- Playlist table is a table of playlists. Playlist uri is a a unique 
-- identifier for each playlist. Name is the name. Added_by is the
-- user that it was added by to the playlist.

CREATE TABLE playlist(
playlist_uri VARCHAR(250) PRIMARY KEY, 
playlist_name VARCHAR(250) NOT NULL, 
added_by VARCHAR(250)
);

-- Track table is a table of tracks. Track uri is a a unique identifier for
-- each track. Name is name. Foreign key artist_uri references the artist
-- that made the track, same thing for album_uri, and playlist_uri.
-- Duration is the length of the song in ms. Preview url is a link to a
-- 30 second preview of the track. Added_at is the timestamp that the track
-- was added.

CREATE TABLE track(
track_uri VARCHAR(250) PRIMARY KEY, 
track_name VARCHAR(250) NOT NULL, 
artist_uri VARCHAR(250) NOT NULL, 
album_uri VARCHAR(250) NOT NULL, 
playlist_uri VARCHAR(250) NOT NULL, 
duration_ms INT NOT NULL, 
preview_url VARCHAR(250),
added_at TIMESTAMP NOT NULL,

FOREIGN KEY (artist_uri) REFERENCES artist(artist_uri)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (album_uri) REFERENCES album(album_uri)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (playlist_uri) REFERENCES playlist(playlist_uri)
ON DELETE CASCADE ON UPDATE CASCADE
);

