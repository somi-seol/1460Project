---tables

CREATE TABLE BorrowRecordTable
(
    BorrowRecordId INT PRIMARY KEY,
    UserId INT FOREIGN KEY REFERENCES UsersTable(UserId),
    MediaItemId INT FOREIGN KEY REFERENCES MediaItemTable(MediaItemId),
    BorrowDate DATE,
    ReturnDate DATE,
)

CREATE TABLE UsersTable
(
    UserId INT PRIMARY KEY,
    UserName TEXT,
    UserEmail TEXT,
)

CREATE TABLE MediaItemTable
(
    MediaItemId INT PRIMARY KEY,
    MediaGenreId INT FOREIGN KEY REFERENCES MediaGenreTable(MediaGenreId),
    MediaTypeId INT FOREIGN KEY REFERENCES MediaTypeTable(MediaTypeId),
    MediaReleaseDate DATE,
    MediaItemRating INT --triggered update?
)

CREATE TABLE MediaItemRatingTable
(
    MediaRatingId INT PRIMARY KEY,
    ItemId INT FOREIGN KEY REFERENCES MediaItemTable(MediaItemId),
    UserId INT FOREIGN KEY REFERENCES UsersTable(UserId),
    MediaItemRating INT
)

CREATE TABLE MediaGenreTable
(
    MediaGenreId INT PRIMARY KEY,
    MediaGenreName TEXT
)

CREATE TABLE MediaTypeTable
(
    MediaTypeId INT PRIMARY KEY,
    MediaTypeName TEXT
)

---procedures

--borrowing proc
CREATE PROCEDURE Borrowing @UserId INT, @MediaItem INT
AS
INSERT INTO BorrowRecordTable (UserId, MediaItemId, BorrowDate)
VALUES (@UserId, @MediaItem, GETDATE())

--returning proc
CREATE PROCEDURE Returning @UserId INT, @MediaItemId INT
AS
UPDATE BorrowRecordTable
SET ReturnDate = GETDATE()
WHERE UserId = @UserId AND MediaItemId = @MediaItemId

--rating proc todo
CREATE PROCEDURE Rating @UserId INT, @ItemId INT, @Rating INT
AS
INSERT INTO MediaItemRatingTable (UserId, MediaItemId, Rating)
VALUES (@UserId, @MediaItem, @Rating)

---views

--view item avg rating todo
-- view item's borrow history todo

---triggers

--update borrow status todo