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