
use master;

create database DT_Library;

USE DT_Library;

-- Create the Users table for storing User details
CREATE TABLE Users (
    UserID int identity(1,1) primary key,
    UserName NVARCHAR(50) UNIQUE not null,
    Phone char(11) check(isNumeric(phone) = 1),
    Email NVARCHAR(100) CHECK (
    Email LIKE '%@%' -- Check if it contains the "@" symbol
    AND Email LIKE '%.%' -- Check if it contains a dot (.) for the domain
    AND Email NOT LIKE '%@%@%' -- Ensure there's only one "@" symbol
    AND Email NOT LIKE '%.%.' -- Ensure there's only one dot (.) for the domain
    AND LEN(Email) <= 100 AND LEN(Email) >= 5 -- -- Maximum and Minimum total length for an email address
    AND CHARINDEX('@', Email) <= LEN(Email) - CHARINDEX('.', REVERSE(Email)) - 1 -- Ensure the "@" is before the last "."
    AND CHARINDEX('@', Email) >= 2 -- Ensure the "@" is not at the beginning
    AND CHARINDEX('.', REVERSE(Email)) >= 2 -- Ensure the "." is not at the end
),
Address nvarchar(200)
);

-- Create the LibraryCards table for storing Library Card details
CREATE TABLE LibraryCards (
    CardID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT UNIQUE NOT NULL, -- Foreign key reference to Users
    StartDate DATE NOT NULL Default GETDATE(), -- Start date of the library card
    EndDate AS DATEADD(YEAR, 1, StartDate) PERSISTED, -- End date is one year from the start date
    CONSTRAINT FK_LibraryCards_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


-- Create the Books table for storing Book details
CREATE TABLE Books (
    ID int identity(1,1) primary key,
	Title NVARCHAR(100) UNIQUE not null,
	ISBN NVARCHAR(25) UNIQUE,
	PublicationDate Date not null,  -- PublicationDate -> تاريخ النشر
	Genre NVARCHAR(50), -- Genre -> النوع
	AdditionalDetails nvarchar(200)
);

-- Create the Authors table for storing Author details
CREATE TABLE Authors (
ID int identity(1,1) primary key,
Name NVARCHAR(50) UNIQUE not null,
DateOfBirth DATE
);

-- Create the AuthorsBooks table for storing AuthorBooks details
CREATE TABLE AuthorsBooks (
    ID int identity(1,1) primary key,
    AuthorID int not null,
    BookID int not null,
    CONSTRAINT FK_AuthorsBooks_AuthorID FOREIGN KEY (AuthorID) REFERENCES Authors(ID),
    CONSTRAINT FK_AuthorsBooks_BookID FOREIGN KEY (BookID) REFERENCES Books(ID),
    CONSTRAINT UC_AuthorsBooks_AuthorID_BookID UNIQUE (AuthorID, BookID)
	-- 'UC_AuthorsBooks_AuthorID_BookID' is added, which ensures 
	-- that combinations of 'AuthorID' and 'BookID' must be unique in the 'AuthorsBooks' table. 
	-- This constraint ensures that you cannot have duplicate pairs of 'AuthorID' and 'BookID' in the table.
);


-- Create the BookCopies table for storing BookCopies details
CREATE TABLE BookCopies (
CopyID int identity(1,1) primary key,
BookID int,
AvailabilityStatus BIT
CONSTRAINT FK_BookCopies_BookID FOREIGN KEY (BookID) REFERENCES Books(ID)
);

-- Create the Reservations table for storing Reservation details
CREATE TABLE Reservations (
ID int identity(1,1) primary key,
UserID int not null,
CopyID int not null,
ReservationDate Date not null, --  ReservationDate -> تاريخ الحجز
CONSTRAINT FK_Reservations_USERID FOREIGN KEY (UserID) REFERENCES Users(UserID),
CONSTRAINT FK_Reservations_CopyID FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID)
);

-- Create the BorrowingRecords table for storing Borrowing details
CREATE TABLE BorrowingRecords (
    BorrowingRecordID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CopyID INT NOT NULL,
    BorrowingDate DATE NOT NULL, -- Date when the book was borrowed (تاريخ الاقتراض)
    DueDate DATE NOT NULL CHECK (DueDate >= BorrowingDate), -- Ensure DueDate is greater than or equal to BorrowingDate. (DueDate Means تاريخ الاستحقاق)
    ReturnDate DATE, -- Actual return date of the book
    IsOverdue BIT, -- Overdue status: 1 indicates the customer is late, 0 indicates the customer is not late
    CONSTRAINT FK_BorrowingRecords_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_BorrowingRecords_CopyID FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID)
);

-- Create the Fines table for storing Fines details
CREATE TABLE Fines (
    FinesID int identity(1,1) primary key,
    UserID int not null,
    BorrowingRecordID int not null,
    NumberOfLateDays smallint not null,
    FineAmount decimal not null,
    PaymentStatus bit,
    CONSTRAINT FK_Fines_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Fines_BorrowingRecordID FOREIGN KEY (BorrowingRecordID) REFERENCES BorrowingRecords(BorrowingRecordID)
);


CREATE TABLE LibrarySettings (
    SettingID int identity(1,1) primary key,
    DefaultBorrowDurationDays tinyint not null,
    DefaultFinePerDay decimal(5, 2) not null
);


-- Test Scripts for Database Verification
-- Important Note: Execute Each Script Separately to Prevent Errors; Avoid Running All at Once Take Care Bro
-- ..........................................................................................................................

-- Example to insert a user and Generate his own LibraryCard
BEGIN TRANSACTION; -- Start a transaction

-- Insert a new User
INSERT INTO Users (UserName, Phone, Email, Address)
VALUES ('Mahmoud Mohamed', '01019060452', 'Mahmoud@example.com', '123 Main St');

-- Get the UserId of the newly inserted User
DECLARE @NewUserId INT;
SELECT @NewUserId = SCOPE_IDENTITY();

-- Insert a new LibraryCard with the corresponding UserId
INSERT INTO LibraryCards (UserID, EndDate)
VALUES (@NewUserId, DATEADD(YEAR, 1, GETDATE())); -- Assuming a 1-year subscription

COMMIT; -- Commit the transaction if both inserts are successful

-----------------------------------------------------------------------------------------------------

-- Example to insert an Author
INSERT INTO Authors (Name, DateOfBirth)
VALUES ('Taha Hussein', '1889-11-14');

-----------------------------------------------------------------------------------------------------

-- Example to insert a Book
INSERT INTO Books (Title, ISBN, PublicationDate, Genre, AdditionalDetails)
VALUES ('The Days', '978-1-123456-00-0', '2023-01-01', 'Autobiography', 'An autobiography of a famous author.');

-----------------------------------------------------------------------------------------------------

-- Link the Author to the Book in AuthorsBooks table
DECLARE @NewAuthorId INT, @NewBookId INT;
SELECT @NewAuthorId = (SELECT ID FROM Authors WHERE Name = 'Taha Hussein'); -- Get the Author ID
SELECT @NewBookId = (SELECT ID FROM Books WHERE Title = 'The Days'); -- Get the Book ID

INSERT INTO AuthorsBooks (AuthorID, BookID)
VALUES (@NewAuthorId, @NewBookId);

--------------------------------------------------------------------------------------------------------

-- Insert a new Book Copy and link it to the Book
DECLARE @NewBookId INT;
SELECT @NewBookId = (SELECT ID FROM Books WHERE Title = 'The Days'); -- Get the Book ID
INSERT INTO BookCopies (BookID, AvailabilityStatus)
VALUES (@NewBookId, 1); -- Assuming the initial availability status is 1 (available)

---------------------------------------------------------------------------------------------------------

-- Insert another Book Copy and link it to the Book
DECLARE @NewBookId INT;
SELECT @NewBookId = (SELECT ID FROM Books WHERE Title = 'The Days'); -- Get the Book ID
INSERT INTO BookCopies (BookID, AvailabilityStatus)
VALUES (@NewBookId, 1); -- Assuming the initial availability status is 1 (available)

---------------------------------------------------------------------------------------------------------

-- Example to perform a Borrowing transaction
-- Assuming you have a LibraryCard for the user and a BookCopy available
-- You need to have the LibraryCardID and BookCopyID to execute this
DECLARE @UserId INT, @LibraryCardID INT, @BookCopyID INT;
SELECT @UserId = (SELECT Users.UserID FROM Users WHERE Users.UserName = 'Mahmoud Mohamed'); -- Get the User ID
SELECT @LibraryCardID = (SELECT CardID FROM LibraryCards WHERE UserID = @UserId);
SELECT @BookCopyID = (SELECT Top 1 CopyID FROM BookCopies WHERE AvailabilityStatus = 1);

-- Perform the Borrowing transaction
BEGIN TRANSACTION;

-- Insert the record into BorrowingRecords
INSERT INTO BorrowingRecords (UserID, CopyID, BorrowingDate, DueDate)
VALUES (@UserId, @BookCopyID, GETDATE(), DATEADD(DAY, 7, GETDATE())); -- Assuming 7-day borrowing period

-- Update the BookCopy's availability status to checked out (0 means checked out)
UPDATE BookCopies
SET AvailabilityStatus = 0
WHERE CopyID = @BookCopyID;

COMMIT; -- Commit the transaction if both inserts are successful

----------------------------------------------------------------------------------------------------------------

Select * from Users
Select * from Authors
Select * from Books
Select * from AuthorsBooks
Select * from BookCopies
Select * from BorrowingRecords
Select * from LibraryCards
Select * from Fines
Select * from Reservations
