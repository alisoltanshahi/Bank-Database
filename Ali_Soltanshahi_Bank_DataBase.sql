/* Create a database called 'BANK'*/
CREATE DATABASE BANK;

/* Switch to the 'BANK' database*/
USE BANK;

/* Create a table to store customer information*/
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(255) NOT NULL,
    Phone_Number VARCHAR(20) NOT NULL UNIQUE,
    Customer_Address VARCHAR(100) NOT NULL,
    Customer_Eaddress VARCHAR(255) NOT NULL UNIQUE,
    Tax_Number VARCHAR(20) NOT NULL UNIQUE,
    Date_Of_Birth DATE NOT NULL,
    Gender ENUM('M', 'F', 'UN') NOT NULL,
    Residence_Status ENUM('tenant', 'Landlord') NOT NULL,
    Marital_Status ENUM('Married', 'Single') NOT NULL,
    Average_Income DECIMAL(10, 2) NOT NULL
);

/* Create a table to store employee information*/
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(30) NOT NULL,
    Last_Name VARCHAR(30) NOT NULL,
    Address TEXT NOT NULL,
    Contact_Address INT NOT NULL,
    Email VARCHAR(30) NOT NULL UNIQUE,
    Password VARCHAR(30) NOT NULL
);

/* Create a table to store account information*/
CREATE TABLE Account (
    Account_ID INT PRIMARY KEY,
    Account_Type VARCHAR(20) NOT NULL,
    Account_Number VARCHAR(20) NOT NULL UNIQUE,
    Current_Balance DECIMAL(10, 2) NOT NULL,
    Date_Opened DATE NOT NULL,
    Date_Closed DATE NULL DEFAULT NULL,
    Account_Status VARCHAR(20) NOT NULL,
    Customer_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee (Employee_ID)
);

/* Create a table to store loan information*/
CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY,
    Loan_Type VARCHAR(20) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Term INT NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Status ENUM('rejected', 'successful') NOT NULL,
    Account_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    FOREIGN KEY (Account_ID) REFERENCES Account (Account_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_ID)
);

/* Create a table to store credit card information*/
CREATE TABLE Credit_Card (
    Card_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Account_ID INT NOT NULL,
    Card_Type ENUM('Silver', 'Gold') NOT NULL,
    Card_Number VARCHAR(20) NOT NULL UNIQUE,
    Expiry_Date DATE NOT NULL,
    Credit_Limit DECIMAL(10, 2) NOT NULL,
    Available_Credit DECIMAL(10, 2) NOT NULL,
    CCV VARCHAR(3) NOT NULL,
    PIN VARCHAR(4) NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_ID),
    FOREIGN KEY (Account_ID) REFERENCES Account (Account_ID)
);

/* Create a table to store debit card information*/
CREATE TABLE Debit_Card (
    Card_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Account_ID INT NOT NULL,
    Card_Number VARCHAR(20) NOT NULL UNIQUE,
    Pin VARCHAR(4) NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_ID),
    FOREIGN KEY (Account_ID) REFERENCES Account (Account_ID)
);

/* Create a table to store transaction information*/
CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    Sender_Account_ID INT NOT NULL,
    Receiver_Account_ID INT NOT NULL,
    Credit_Card_ID INT NULL DEFAULT NULL,
    Debit_Card_ID INT NULL DEFAULT NULL,
    Employee_ID INT NULL DEFAULT NULL,
    Transaction_Name VARCHAR(255) NOT NULL,
    Transaction_Date DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status ENUM('rejected', 'successful') NOT NULL,
    Reference VARCHAR(255) NULL,
    FOREIGN KEY (Sender_Account_ID) REFERENCES Account (Account_ID),
    FOREIGN KEY (Receiver_Account_ID) REFERENCES Account (Account_ID),
    FOREIGN KEY (Credit_Card_ID) REFERENCES Credit_Card (Card_ID),
    FOREIGN KEY (Debit_Card_ID) REFERENCES Debit_Card (Card_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee (Employee_ID)
);

/* Create a trigger to check credit card availability*/
DELIMITER $$
CREATE TRIGGER CheckCreditCardAvailability
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE credit_card_avail DECIMAL(10, 2);
    
    -- Get the current available credit of the associated credit card
    SELECT Available_Credit INTO credit_card_avail
    FROM Credit_Card
    WHERE Card_ID = NEW.Credit_Card_ID;
    
    IF credit_card_avail >= NEW.Amount THEN
        -- Update the transaction status to 'successful'
        UPDATE Transactions
        SET Status = 'successful'
        WHERE Transaction_ID = NEW.Transaction_ID;
    ELSE
        -- Update the transaction status to 'rejected'
        UPDATE Transactions
        SET Status = 'rejected'
        WHERE Transaction_ID = NEW.Transaction_ID;
    END IF;
END;
$$
DELIMITER ;

/* Create a trigger to check loan amount*/
DELIMITER $$
CREATE TRIGGER CheckLoanAmount
BEFORE INSERT ON Loan
FOR EACH ROW
BEGIN
    DECLARE avg_income DECIMAL(10, 2);
    
    -- Get the average income of the associated customer
    SELECT Average_Income INTO avg_income
    FROM Customer
    WHERE Customer_ID = NEW.Customer_ID;
    
    IF NEW.Amount > (5 * avg_income) THEN
        -- Set the status of the loan to 'rejected'
        SET NEW.Status = 'rejected';
    END IF;
END;
$$
DELIMITER ;
ALTER TABLE Transactions
MODIFY Transaction_Date DATETIME DEFAULT NOW();
DELIMITER $$
CREATE PROCEDURE GenerateMonthlyStatements()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE account_id INT;
    DECLARE cur CURSOR FOR
        SELECT Account_ID
        FROM Account
        WHERE Account_Status = 'Active';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO account_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Generate and print the account statement for the given account_id
        -- This section of code would involve querying transaction data, calculating balances, and formatting the statement.
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;