CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Books (
    Book_ID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Genre VARCHAR(100),
    Availability BOOLEAN DEFAULT TRUE
);

INSERT INTO Books (Title, Author, ISBN, Genre) VALUES
('Harry Potter', 'J.K. Rowling', '123456789', 'Fantasy'),
('The Hobbit', 'J.R.R. Tolkien', '987654321', 'Adventure');

CREATE TABLE Members (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    JoinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Members (Name, Email, Phone) VALUES
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '8765432109');

SELECT * FROM Books;

CREATE TABLE Borrowing (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Member_ID INT,
    Book_ID INT,
    Borrow_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fix: Changed DATE to TIMESTAMP
    Return_Date DATE,
    Status ENUM('Borrowed', 'Returned') DEFAULT 'Borrowed',
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

INSERT INTO Borrowing (Member_ID, Book_ID, Return_Date)
VALUES 
(1, 2, '2025-03-10');  -- Member 1 borrowed Book 2, return due on March 10

UPDATE Books 
SET Availability = 0  -- 0 means the book is borrowed (not available)
WHERE Book_ID = 2;     -- Change to the actual Book_ID

SELECT 
    b.Book_ID, 
    b.Title, 
    m.Name AS Borrower, 
    br.Borrow_Date, 
    br.Return_Date, 
    br.Status
FROM Borrowing br
JOIN Books b ON br.Book_ID = b.Book_ID
JOIN Members m ON br.Member_ID = m.Member_ID
WHERE br.Status = 'Borrowed';

SELECT 
    b.Title, 
    m.Name AS Borrower, 
    br.Borrow_Date, 
    br.Return_Date
FROM Borrowing br
JOIN Books b ON br.Book_ID = b.Book_ID
JOIN Members m ON br.Member_ID = m.Member_ID
WHERE br.Return_Date < CURDATE() AND br.Status = 'Borrowed';

UPDATE Borrowing 
SET Status = 'Returned' 
WHERE Transaction_ID = 1;  -- Change to the actual Transaction_ID

UPDATE Books 
SET Availability = 1  -- 1 means available
WHERE Book_ID = 2;  -- Change to the actual Book_ID

SELECT * FROM Books WHERE Availability = 1;

DELIMITER //
CREATE TRIGGER after_borrowing_insert
AFTER INSERT ON Borrowing
FOR EACH ROW
BEGIN
    UPDATE Books SET Availability = 0 WHERE Book_ID = NEW.Book_ID;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_borrowing_update
AFTER UPDATE ON Borrowing
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Returned' THEN
        UPDATE Books SET Availability = 1 WHERE Book_ID = NEW.Book_ID;
    END IF;
END;
//
DELIMITER ;









