--tables

CREATE TABLE Users
(
    UserId INT PRIMARY KEY,
    UserName TEXT,
    UserEmail TEXT,
    BorrowRecordId INT FOREIGN KEY REFERENCES BorrowRecords(BorrowRecordId)
)

CREATE TABLE BorrowRecords
(
    BorrowRecordId INT PRIMARY KEY,
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    ItemId INT FOREIGN KEY REFERENCES Items(ItemId),
    BorrowDate DATETIME,
    ReturnDate DATETIME,
    BorrowStatus TEXT
)

CREATE TABLE Items
(
    ItemId INT PRIMARY KEY,
    GenreId INT FOREIGN KEY REFERENCES Genres(GenreId),
    MediaTypeId INT FOREIGN KEY REFERENCES MediaTypes(MediaTypeId),
    ReleaseDate DATETIME,
    Rating INT
)

CREATE TABLE Genres
(
    GenreId INT PRIMARY KEY,
    GenreName TEXT
)

CREATE TABLE MediaTypes
(
    MediaTypeId INT PRIMARY KEY,
    MediaTypeName TEXT
)

--procedures

CREATE PROCEDURE InsertData @TableName TEXT, @Column1 TEXT, @Value1 TEXT
AS
INSERT INTO @TableName (@Column1)
VALUES (@Value1)
GO;

CREATE PROCEDURE UpdateData @Param1 TEXT, @Condition1 INT
AS
UPDATE TableName
SET Column1 = @Param1
WHERE Condition1 = @Condition1
GO;

CREATE PROCEDURE RetrieveData @TableName TEXT, @Condition1 INT
SELECT * FROM @TableName WHERE Condition1 = @Condition1
GO;

CREATE PROCEDURE DeleteData @TableName TEXT, @Condition1 INT
DELETE FROM @TableName WHERE @Condition1;