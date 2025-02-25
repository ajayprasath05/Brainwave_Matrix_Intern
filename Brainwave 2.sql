-- Create the database
CREATE DATABASE OnlineStore;
USE OnlineStore;

-- Create Products table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address TEXT,
    Phone VARCHAR(15)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2),
    Status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderDetails table to store order items
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    SubTotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Payments table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery') NOT NULL,
    Status ENUM('Successful', 'Failed', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert sample products
INSERT INTO Products (Name, Description, Price, Stock) VALUES
('Laptop', 'High-performance laptop', 75000, 10),
('Smartphone', 'Latest model smartphone', 40000, 20),
('Headphones', 'Noise-cancelling headphones', 5000, 30);

-- Insert sample customers
INSERT INTO Customers (Name, Email, Address, Phone) VALUES
('Alice Johnson', 'alice@example.com', '123 Main St, Chennai', '9876543210'),
('Bob Smith', 'bob@example.com', '456 Park Ave, Bangalore', '8765432109');

-- Insert a sample order
INSERT INTO Orders (CustomerID, TotalAmount, Status) VALUES (1, 75000, 'Pending');

-- Insert order details (Customer Alice orders 1 Laptop)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, SubTotal) VALUES (1, 1, 1, 75000);

-- Insert a payment record
INSERT INTO Payments (OrderID, Amount, PaymentMethod, Status) VALUES (1, 75000, 'Credit Card', 'Successful');

SELECT o.OrderID, c.Name AS CustomerName, o.OrderDate, o.TotalAmount, o.Status 
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

SELECT ProductID, Name, Stock 
FROM Products 
WHERE ProductID = 1;

UPDATE Products 
SET Stock = Stock - 1 
WHERE ProductID = 1;

UPDATE Orders 
SET Status = 'Shipped' 
WHERE OrderID = 1;

SELECT * FROM Payments WHERE OrderID = 1;

