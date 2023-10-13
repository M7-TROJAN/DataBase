# DT_Library Database

The DT_Library database is designed to manage a library's operations, including user information, book records, borrowing, and more. 
Below is a detailed description of the tables and their relationships.

## Tables

### Users

The `Users` table stores user details.

- `UserID` (Primary Key): Unique identifier for users.
- `UserName`: User's name.
- `Phone`: User's phone number.
- `Email`: User's email address.
- `Address`: User's address.

### LibraryCards

The `LibraryCards` table stores library card details.

- `CardID` (Primary Key): Unique identifier for library cards.
- `UserID` (Foreign Key): Reference to the user associated with the library card.
- `StartDate`: Start date of the library card.
- `EndDate`: End date of the library card.

### Books

The `Books` table stores book details.

- `ID` (Primary Key): Unique identifier for books.
- `Title`: Book title.
- `ISBN`: International Standard Book Number.
- `PublicationDate`: Date of publication.
- `Genre`: Book genre.
- `AdditionalDetails`: Additional information about the book.

### Authors

The `Authors` table stores author details.

- `ID` (Primary Key): Unique identifier for authors.
- `Name`: Author's name.
- `DateOfBirth`: Author's date of birth.

### AuthorsBooks

The `AuthorsBooks` table establishes a many-to-many relationship between authors and books.

- `ID` (Primary Key): Unique identifier for author-book relationships.
- `AuthorID` (Foreign Key): Reference to the author.
- `BookID` (Foreign Key): Reference to the book.

### BookCopies

The `BookCopies` table stores book copy details.

- `CopyID` (Primary Key): Unique identifier for book copies.
- `BookID` (Foreign Key): Reference to the book.
- `AvailabilityStatus`: Indicates the availability of the book copy.

### Reservations

The `Reservations` table stores book reservation details.

- `ID` (Primary Key): Unique identifier for reservations.
- `UserID` (Foreign Key): Reference to the user who made the reservation.
- `CopyID` (Foreign Key): Reference to the reserved book copy.
- `ReservationDate`: Date of the reservation.

### BorrowingRecords

The `BorrowingRecords` table stores book borrowing details.

- `BorrowingRecordID` (Primary Key): Unique identifier for borrowing records.
- `UserID` (Foreign Key): Reference to the user who borrowed the book.
- `CopyID` (Foreign Key): Reference to the borrowed book copy.
- `BorrowingDate`: Date when the book was borrowed.
- `DueDate`: Date when the book is due (must be greater than or equal to `BorrowingDate`).
- `ReturnDate`: Actual return date of the book.
- `IsOverdue`: Overdue status (1 indicates the customer is late, 0 indicates the customer is not late).

### Fines

The `Fines` table stores fine details.

- `FinesID` (Primary Key): Unique identifier for fines.
- `UserID` (Foreign Key): Reference to the user with fines.
- `BorrowingRecordID` (Foreign Key): Reference to the borrowing record associated with the fine.
- `NumberOfLateDays`: The number of days the book was late.
- `FineAmount`: The amount of the fine.
- `PaymentStatus`: Indicates the payment status of the fine.

## Sample Scripts

### Creating a User and Library Card

To insert a new user and generate their library card, use the following script:

```sql
-- Insert a new User
-- INSERT INTO Users (UserName, Phone, Email, Address) VALUES ...

-- Get the UserId of the newly inserted User

-- Insert a new LibraryCard with the corresponding UserId
-- INSERT INTO LibraryCards (UserID, EndDate) VALUES ...
```

## Inserting an Author
To insert an author, use the following script:
```sql
-- Insert an Author
-- INSERT INTO Authors (Name, DateOfBirth) VALUES ...
```

## Inserting a Book
To insert a book, use the following script:
```sql
-- Insert a Book
-- INSERT INTO Books (Title, ISBN, PublicationDate, Genre, AdditionalDetails) VALUES ...
```

## Linking an Author to a Book
To link an author to a book, use the following script:
```sql
-- Link the Author to the Book in AuthorsBooks table
-- INSERT INTO AuthorsBooks (AuthorID, BookID) VALUES ...
```

Borrowing a Book
To perform a borrowing transaction, use the following script:
```sql
-- Insert the record into BorrowingRecords
-- INSERT INTO BorrowingRecords (UserID, CopyID, BorrowingDate, DueDate) VALUES ...

-- Update the BookCopy's availability status to checked out
-- UPDATE BookCopies SET AvailabilityStatus = 0 WHERE ...
```
