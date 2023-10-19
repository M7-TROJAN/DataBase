-- Test Scripts for Database Verification Important 
-- Note: Execute Each Script Separately to Prevent Errors; Avoid Running All at Once Take Care, Bro


Use Car_Rental;

-- Insert sample fuel types into the FuelTypes table
INSERT INTO FuelTypes (ID, FuelType) VALUES
(1, 'Gasoline (Petrol)'),
(2, 'Diesel'),
(3, 'Electric'),
(4, 'Hybrid');

---------------------------------------------------------------------------------------------------------------------

-- Insert sample vehicle categories into the VehiclesCategory table
INSERT INTO VehiclesCategory (CategoryName) VALUES
('4x4'),
('Sedan'),
('SUV'),
('Sports Car'),
('Minivan');

---------------------------------------------------------------------------------------------------------------------


-- Insert Vehicles

-- Insert a Vehicles
INSERT INTO Vehicles (Make, Model, Year, mileage, FuelTypeID, PlateNumber, CarCategoryID, RentalPricePerDay, ISAvilableForRent)
VALUES ('Toyota', 'Camry', '2021-01-01', 10000, 1, 'ABC123', 1, 50.00, 1),
	   ('Tesla', 'Model 3', '2023-01-01', 0, 4, 'TESLA001', 2, 80.00, 1);

-- Insert a Vehicle by specifying FuelType and CarCategory
DECLARE @FuelTypeID INT, @CarCategoryID INT;

-- Get the FuelTypeID for 'Gasoline' fuel type
SELECT @FuelTypeID = ID FROM FuelTypes WHERE FuelType LIKE '%Gasoline%';

-- Get the CarCategoryID for 'Sports' category
SELECT @CarCategoryID = CategoryID FROM VehiclesCategory WHERE CategoryName LIKE '%Sports%';

-- Insert the vehicle into the Vehicles table
INSERT INTO Vehicles (Make, Model, Year, Mileage, FuelTypeID, PlateNumber, CarCategoryID, RentalPricePerDay, ISAvilableForRent)
VALUES ('Honda', 'Civic', '2020-01-01', 8000, @FuelTypeID, 'XYZ789', @CarCategoryID, 45.00, 1);

---------------------------------------------------------------------------------------------------------------------


-- Example to insert customers

-- Insert the first customer
INSERT INTO Customers (CustomerName, National_ID_Number, Driver_License_Number, Phone)
VALUES ('Mahmoud Mohamed', '29803031401528', '56789012345678', '01019760452');

-- Insert the second customer
INSERT INTO Customers (CustomerName, National_ID_Number, Driver_License_Number, Phone)
VALUES ('Mohamed Salah', '30003031491528', '43210987654321', '01129416608');

---------------------------------------------------------------------------------------------------------------------


-- Example to insert a booking record

-- Start a transaction
BEGIN TRANSACTION;

-- Declare variables for input data
DECLARE @CustomerID INT, @VehicleID INT, @RentalDurationDays TINYINT, 
@PickupLocation NVARCHAR(100), @DropOffLocation NVARCHAR(100), 
@RentalPricePerDay SMALLMONEY, @InitialCheckNotes NVARCHAR(500);

-- Assign values to the variables

-- Assume that the customer who is going to rent the car already exists in the database, 
-- so we don't need to include him as a new record
SELECT @CustomerID = (SELECT CustomerID FROM Customers WHERE CustomerName = 'Mahmoud Mohamed');

-- Retrieve the VehicleID from the Vehicles table
SELECT @VehicleID = (SELECT TOP 1 VehicleID FROM Vehicles 
WHERE Make = 'Toyota' AND Year = '2021-01-01' AND Model = 'Camry' AND ISAvilableForRent = 1);

-- Retrieve the RentalPricePerDay from the Vehicles table Based On VehicleID
SELECT @RentalPricePerDay = (SELECT RentalPricePerDay FROM Vehicles WHERE VehicleID = @VehicleID);

-- Set other variables
SELECT @RentalDurationDays = 7;
SELECT @PickupLocation = 'Test Pickup Location';
SELECT @DropOffLocation = 'Test DropOff Location';
SELECT @InitialCheckNotes = 'Test Check Notes';

-- Insert the rental booking record
INSERT INTO RentalBooking (CustomerID, VehicleID, RentalDurationDays, RentalStartDate, PickupLocation, DropOffLocation, RentalPricePerDay, InitialCheckNotes)
VALUES (
    @CustomerID,
    @VehicleID,
    @RentalDurationDays,
    GETDATE(), -- Use the current date as the start date 
    @PickupLocation,
    @DropOffLocation,
    @RentalPricePerDay,
    @InitialCheckNotes
);

-- Check if the insertion was successful
IF @@ERROR = 0
BEGIN
    -- If successful, commit the transaction
	-- Note: Don't Forget To Set 'ISAvilableForRent' Vehicles Column To 0
	UPDATE Vehicles
	SET ISAvilableForRent = 0
	WHERE VehicleID = @VehicleID;

    COMMIT;
    PRINT 'Transaction committed successfully.';
END
ELSE
BEGIN
    -- If unsuccessful, roll back the transaction
    ROLLBACK;
    PRINT 'Transaction rolled back due to an error.';
END;

---------------------------------------------------------------------------------------------------------------------



-- Example for Inserting a Record into VehicleReturns table and RentalTransaction table:

-- Start a transaction
BEGIN TRANSACTION;

-- Declare variables for input data
DECLARE 
@BookingID INT, 
@ActualReturnDate DATETIME,
@ActualRentalDays TINYINT,
@Mileage SMALLINT,
@ConsumedMileage SMALLINT,
@FinalCheckNotes NVARCHAR(500),
@AdditionalCharges SMALLMONEY, 
@ActualTotalDueAmount SMALLMONEY;

-- Assign values to the variables

SELECT @BookingID = 1; -- Replace with the actual BookingID
SELECT @ActualReturnDate = '2023-10-25 12:00:00';

-- Calculate the number of rental days
SELECT @ActualRentalDays = DATEDIFF(DAY, (SELECT RentalStartDate FROM RentalBooking WHERE BookingID = @BookingID), @ActualReturnDate);


SELECT @Mileage = 10200; -- Replace with the actual Mileage

-- Calculate the consumed mileage
SELECT @ConsumedMileage = @Mileage - (SELECT Vehicles.mileage
FROM RentalBooking
JOIN Vehicles ON Vehicles.VehicleID = RentalBooking.VehicleID
WHERE RentalBooking.BookingID = @BookingID);

-- Set other variables
SELECT @FinalCheckNotes = 'All good'; -- Replace with the actual notes
SELECT @AdditionalCharges = 25.00; -- Replace with the actual charges

-- Calculate the actual total due amount
-- To determine the total due amount, we first need to fetch the 'RentalPricePerDay' from the Vehicles table, 
-- which is based on the VehicleID obtained from the RentalBooking table using the @BookingID.
-- Next, we calculate the total by multiplying '@ActualRentalDays' by 'RentalPricePerDay' and adding the '@AdditionalCharges'.

DECLARE @VehicleID INT;

-- Retrieve the VehicleID associated with the @BookingID from the RentalBooking table, 
-- which we will use to fetch the 'RentalPricePerDay' from the Vehicles table.
SELECT @VehicleID = (SELECT VehicleID FROM RentalBooking WHERE BookingID = @BookingID)
PRINT @VehicleID

-- Calculate the actual total due amount, taking into account the rental duration and any additional charges.
SELECT @ActualTotalDueAmount = (@ActualRentalDays * (SELECT RentalPricePerDay FROM Vehicles WHERE VehicleID = @VehicleID)) + @AdditionalCharges;


-- Insert the record into the VehicleReturns table
INSERT INTO VehicleReturns (BookingID, ActualReturnDate, ActualRentalDays, Mileage, ConsumedMileage, FinalCheckNotes, AdditionalCharges, ActualTotalDueAmount)
VALUES (
	@BookingID, 
	@ActualReturnDate, 
	@ActualRentalDays, 
	@Mileage, 
	@ConsumedMileage, 
	@FinalCheckNotes, 
	@AdditionalCharges, 
	@ActualTotalDueAmount
);

-- Retrieve the ReturnID of the inserted record
DECLARE @ReturnID INT;
SELECT @ReturnID = SCOPE_IDENTITY();

-- Retrieve the InitialTotalDueAmount From The RentalBooking Table
DECLARE @PaidInitialTotalDueAmount SMALLMONEY;
SELECT @PaidInitialTotalDueAmount = (SELECT InitialTotalDueAmount FROM RentalBooking WHERE BookingID = @BookingID);

-- Insert the corresponding record into the RentalTransaction table
INSERT INTO RentalTransaction (
	BookingID, ReturnID, PaymentDetails, PaidInitialTotalDueAmount, ActualTotalDueAmount, 
	TotalRemaining, TotalRefundedAmount, TransactionDate, UpdatedTransactionDate)
VALUES (
	@BookingID, 
	@ReturnID, 
	'Payment received for initial booking',  -- Provide more specific information about the payment
	100.00, 
	@ActualTotalDueAmount, 
	---- Calculate TotalRemaining
	CASE
		WHEN @ActualTotalDueAmount > @PaidInitialTotalDueAmount THEN @ActualTotalDueAmount - @PaidInitialTotalDueAmount
		ELSE 0.00  -- Ensure that TotalRemaining is not negative
	END,
	-- Calculate TotalRefundedAmount
	CASE
		WHEN @PaidInitialTotalDueAmount > @ActualTotalDueAmount THEN @PaidInitialTotalDueAmount - @ActualTotalDueAmount
		ELSE 0.00  -- Ensure that TotalRefundedAmount is not negative
	END,
	GETDATE(), 
	NULL
);


-- Check if the insertion was successful
IF @@ERROR = 0
BEGIN
    -- If successful, commit the transaction

	-- Note: Don't Forget To Update 'mileage' Vehicles Column To The New Mileage '@Mileage'
	UPDATE Vehicles
    SET mileage = @Mileage
    WHERE VehicleID = @VehicleID;

	-- Note: Set 'ISAvilableForRent' in the Vehicles table to 1 if the FinalCheckNotes indicate that the vehicle is in good condition
    -- (Assuming '0' represents a problem with the car)
    IF @FinalCheckNotes <> '0'
    BEGIN
        UPDATE Vehicles
        SET ISAvilableForRent = 1
        WHERE VehicleID = @VehicleID;
    END

    COMMIT;
    PRINT 'Transaction committed successfully.';
END
ELSE
BEGIN
    -- If unsuccessful, roll back the transaction
    ROLLBACK;
    PRINT 'Transaction rolled back due to an error.';
END;

---------------------------------------------------------------------------------------------------------------------

-- Maintenance for Vehicle 1
INSERT INTO Maintenance (VehicleID, MaintenanceDescription, MaintenanceCost)
VALUES (11, 'Oil Change', 50.00);

-- Maintenance for Vehicle 2
INSERT INTO Maintenance (VehicleID, MaintenanceDescription, MaintenanceCost)
VALUES (12, 'Brake Inspection', 75.00);

-- Maintenance for Vehicle 1
INSERT INTO Maintenance (VehicleID, MaintenanceDescription, MaintenanceCost)
VALUES (13, 'Tire Rotation', 30.00);

-- Maintenance for Vehicle 3
INSERT INTO Maintenance (VehicleID, MaintenanceDescription, MaintenanceCost)
VALUES (14, 'Air Filter Replacement', 20.00);

-- Maintenance for Vehicle 2
INSERT INTO Maintenance (VehicleID, MaintenanceDescription, MaintenanceCost)
VALUES (15, 'Coolant Flush', 60.00);

---------------------------------------------------------------------------------------------------------------------

-- Retrieve and display customer information
SELECT * FROM Customers;

-- Retrieve and display vehicle details
SELECT * FROM Vehicles;

-- Retrieve and display maintenance records
SELECT * FROM Maintenance;

-- Retrieve and display rental booking records
SELECT * FROM RentalBooking;

-- Retrieve and display rental transaction records
SELECT * FROM RentalTransaction;

-- Retrieve and display vehicle return records
SELECT * FROM VehicleReturns;
