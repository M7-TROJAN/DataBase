# Karate Club Database

The Karate Club database is designed to manage information about the club's members, instructors, belt ranks, payments, and belt tests. It includes several tables that store relevant data and relationships between them. Below is a description of the tables and some sample scripts for database verification.

## Tables

### Persons

The `Persons` table stores details about club members and instructors.

- `PersonId` (Primary Key): Unique identifier for persons.
- `Name`: Name of the person.
- `DateOfBirth`: Date of birth.
- `Gender`: Gender (M for Male, F for Female).
- `Phone`: Phone number.
- `Email`: Email address.
- `Address`: Address.
- Constraints:
  - `Name` is unique.

### Instructors

The `Instructors` table stores details about the club's instructors.

- `InstructorID` (Primary Key): Unique identifier for instructors.
- `PersonId` (Foreign Key): Reference to the person associated with the instructor.
- `Qualifications`: Instructor's qualifications.

### BeltRanks

The `BeltRanks` table stores details about different belt ranks.

- `RankID` (Primary Key): Unique identifier for belt ranks.
- `RankName`: Name of the belt rank.
- `TestFees`: Fees for taking a test to achieve the belt rank.
- `BeltRankDescription`: Additional information about the belt rank.

### Members

The `Members` table stores details about club members.

- `MemberID` (Primary Key): Unique identifier for members.
- `PersonId` (Foreign Key): Reference to the person associated with the member.
- `LastBeltRank` (Foreign Key): Reference to the member's last achieved belt rank.
- `IsActive`: Indicates if the member is currently active.

### MemberInstructors

The `MemberInstructors` table stores relationships between members and instructors.

- `MemberID` (Foreign Key): Reference to the member.
- `InstructorID` (Foreign Key): Reference to the instructor.
- `AssignDate`: Date of assignment.

### Payments

The `Payments` table stores details about payments made by members.

- `PaymentID` (Primary Key): Unique identifier for payments.
- `Amount`: Payment amount.
- `Date`: Payment date.
- `MemberID` (Foreign Key): Reference to the member associated with the payment.

### SubscriptionPeriods

The `SubscriptionPeriods` table stores details about subscription periods.

- `PeriodID` (Primary Key): Unique identifier for subscription periods.
- `StartDate`: Start date of the subscription period.
- `EndDate`: End date (one year from the start date).
- `Fees`: Subscription fees.
- `MemberID` (Foreign Key): Reference to the member associated with the subscription period.
- `PaymentID` (Foreign Key): Reference to the payment associated with the subscription period.

### BeltTests

The `BeltTests` table stores details about belt tests.

- `TestID` (Primary Key): Unique identifier for belt tests.
- `MemberID` (Foreign Key): Reference to the member taking the test.
- `RankID` (Foreign Key): Reference to the belt rank being tested.
- `Result`: Test result (0 for failed, 1 for passed).
- `Date`: Test date.
- `TestedByInstructorID` (Foreign Key): Reference to the instructor who conducted the test.
- `PaymentID` (Foreign Key): Reference to the payment associated with the test.

## Sample Scripts

### Inserting an Instructor with Qualifications

To insert a new instructor with qualifications, use the following script:

```sql
-- Insert a new Person
-- INSERT INTO Persons (Name, DateOfBirth, Gender, Phone, Email, Address) VALUES ...

-- Get the PersonId of the newly inserted Person

-- Insert a new Instructor with the corresponding PersonId and Qualifications
-- INSERT INTO Instructors(PersonId, Qualifications) VALUES ...
