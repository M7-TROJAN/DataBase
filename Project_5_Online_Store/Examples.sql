-- This File Contains Some Example Queries for Using the OnlineStore Database Schema
-- These queries demonstrate how to perform various operations with the database, such as updating customer information,
-- retrieving orders, calculating sales, and more. You can use these examples as a reference to understand and work with the database.

-- Example 1: Updating Customer Information
-- Update customer information
UPDATE Customers
SET Phone = '1234567890', Address = '456 Elm St'
WHERE CustomerName = 'Mahmoud Mohamed';


-- Example 2: Retrieving Orders for a Specific Customer
-- Retrieve orders for a specific customer
SELECT Orders.OrderID, Orders.OrderDate, ProductCatalog.ProductName, OrderItems.Quantity, OrderItems.Price
FROM Orders
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN ProductCatalog ON OrderItems.ProductID = ProductCatalog.ProductID
WHERE Orders.CustomerID = (SELECT CustomerID FROM Customers WHERE CustomerName = 'Mahmoud Mohamed');


-- Example 3: Calculating Total Sales for Each Product Category
-- Calculate total sales for each product category
SELECT ProductCategory.CategoryName, SUM(OrderItems.Quantity) AS TotalQuantitySold, SUM(OrderItems.TotalItemsPrice) AS TotalSalesAmount
FROM ProductCategory
LEFT JOIN ProductCatalog ON ProductCategory.CategoryID = ProductCatalog.CategoryID
LEFT JOIN OrderItems ON ProductCatalog.ProductID = OrderItems.ProductID
GROUP BY ProductCategory.CategoryName;


-- Example 4: Retrieving the Latest Reviews with Customer Information
-- Retrieve the latest reviews along with customer information
SELECT Customers.CustomerName, Reviews.ReviewText, Reviews.Rating, Reviews.ReviewDate
FROM Reviews
JOIN Customers ON Reviews.CustomerID = Customers.CustomerID
ORDER BY Reviews.ReviewDate DESC
LIMIT 5; -- This limit the results to the latest 5 reviews


-- Example 5: Finding Products with Low Stock
-- Find products with low stock
SELECT ProductCatalog.ProductName, ProductCatalog.QuantityInStock
FROM ProductCatalog
WHERE ProductCatalog.QuantityInStock < 10;


-- Example 6: Retrieving Orders by Shipping Status
-- Retrieve orders by shipping status
SELECT Orders.OrderID, Orders.OrderDate, OrderStatus.StatusName
FROM Orders
JOIN OrderStatus ON Orders.StatusID = OrderStatus.StatusID;
