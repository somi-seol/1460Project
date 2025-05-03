---tables

CREATE TABLE BorrowRecordTable
(
    BorrowRecordId INT PRIMARY KEY,
    UserId INT,
    MediaItemId INT,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (UserId) REFERENCES UsersTable(UserId),
    FOREIGN KEY (MediaItemId) REFERENCES MediaItemTable(MediaItemId)
);

CREATE TABLE UsersTable
(
    UserId INT PRIMARY KEY,
    UserName TEXT,
    UserEmail TEXT
);

CREATE TABLE MediaItemTable
(
    MediaItemId INT PRIMARY KEY,
    MediaGenreId INT,
    MediaTypeId INT,
    MediaItemTitle TEXT,
    MediaReleaseDate DATE,
    MediaItemAverageRating INT, --triggered update
    FOREIGN KEY (MediaGenreId) REFERENCES MediaGenreTable(MediaGenreId),
    FOREIGN KEY (MediaTypeId) REFERENCES MediaTypeTable(MediaTypeId)
);

CREATE TABLE MediaItemRatingTable
(
    MediaRatingId INT PRIMARY KEY,
    UserId INT,
    MediaItemId INT,
    MediaItemRating INT,
    FOREIGN KEY (UserId) REFERENCES UsersTable(UserId),
    FOREIGN KEY (MediaItemId) REFERENCES MediaItemTable(MediaItemId)
);

CREATE TABLE MediaGenreTable
(
    MediaGenreId INT PRIMARY KEY,
    MediaGenreName TEXT
);

CREATE TABLE MediaTypeTable
(
    MediaTypeId INT PRIMARY KEY,
    MediaTypeName TEXT
);

---views

--view item's avg rating todo
CREATE VIEW MediaItemAverageRating
AS
SELECT
    MediaItemTitle AS Title,
    MediaItemAverageRating AS [Average Rating]
FROM
    MediaItemTable;

--view item's borrow history todo
CREATE VIEW MediaItemBorrowHistory AS
SELECT
    MediaItemTable.MediaItemId,
    MediaItemTable.MediaItemTitle,
    UsersTable.UserId,
    UsersTable.UserName,
    BorrowRecordTable.BorrowDate,
    BorrowRecordTable.ReturnDate
FROM
    MediaItemTable
    JOIN BorrowRecordTable ON MediaItemTable.MediaItemId = BorrowRecordTable.MediaItemId
    JOIN UsersTable ON BorrowRecordTable.UserId = UsersTable.UserId
ORDER BY
    MediaItemTable.MediaItemTitle DESC;

---triggers

--update rating when inserting rating into mediaitemratingtable todo
CREATE TRIGGER UpdateAverageRatingTrigger
AFTER INSERT ON MediaItemRatingTable
BEGIN
    UPDATE MediaItemTable
    SET MediaItemAverageRating =
    (
        SELECT AVG(MediaItemRating)
        FROM MediaItemRatingTable
        WHERE MediaItemId = NEW.MediaItemId
    )
    WHERE MediaItemId = NEW.MediaItemId;
END;


---procedures

--borrowing proc
CREATE PROCEDURE Borrowing @UserId INT, @MediaItem INT
AS
INSERT INTO BorrowRecordTable
    (
        UserId,
        MediaItemId,
        BorrowDate
    )
VALUES
    (
        @UserId,
        @MediaItem,
        CURRENT_DATE
    );

--returning proc
CREATE PROCEDURE Returning @UserId INT, @MediaItemId INT
AS
UPDATE BorrowRecordTable
SET ReturnDate = CURRENT_DATE
WHERE UserId = @UserId AND MediaItemId = @MediaItemId;

--rating proc todo
CREATE PROCEDURE Rating @UserId INT, @ItemId INT, @Rating INT
AS
INSERT INTO MediaItemRatingTable (UserId, MediaItemId, MediaItemRating)
VALUES (@UserId, @MediaItem, @Rating);


--EXAMPLE DATA
INSERT INTO UsersTable (UserId, UserName, UserEmail) VALUES
(1, 'Alice Smith', 'alice@example.com'),
(2, 'Bob Johnson', 'bob@example.com'),
(3, 'Charlie Brown', 'charlie@example.com');

INSERT INTO MediaTypeTable (MediaTypeId, MediaTypeName) VALUES
(1, 'Book'),
(2, 'Movie'),
(3, 'Album');

INSERT INTO MediaGenreTable (MediaGenreId, MediaGenreName) VALUES
(1, 'Scifi'),
(2, 'Romance'),
(3, 'Horror')

INSERT INTO MediaItemTable (MediaItemId, MediaGenreId, MediaTypeId, MediaItemTitle, MediaReleaseDate, MediaItemAverageRating) VALUES
(1, 1, 1, 'Dune', '1965-08-01', NULL),
(2, 1, 2, 'La La Land', '2016-12-09', NULL),
(3, 1, NULL, 'Greatest Hits', '2005-06-21', NULL); --example null value for genre

INSERT INTO BorrowRecordTable (BorrowRecordId, UserId, MediaItemId, BorrowDate, ReturnDate) VALUES
(1, 1, 1, '2025-04-01', '2025-04-15'),
(2, 2, 2, '2025-04-02', '2025-04-18'),
(3, 3, 3, '2025-04-03', NULL); -- still borrowed

INSERT INTO MediaItemRatingTable (MediaRatingId, UserId, MediaItemId, MediaItemRating) VALUES
(1, 1, 1, 5),
(2, 2, 1, 4),
(3, 3, 2, 5);