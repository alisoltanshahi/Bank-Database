SQL Code for a Bank Database

This repository provides SQL code for constructing a database for a single-branch bank to manage customer, employee, account, loan, credit card, debit card, and transaction information.

Introduction
I created a one-of-a-kind bank database with a unique feature: it's designed for a bank with only one branch. My devotion to the goals of the CAP theorem drove me to use this unconventional method. According to the CAP theorem, achieving all three components—consistency, availability, and partition tolerance—at the same time is difficult. I emphasize consistency and availability above partition tolerance in this project. Investigate this project to learn how a single-branch bank database may achieve excellent consistency and availability while avoiding the complexity of partition tolerance. It is critical to know that completing all three components at the same time is impossible.
Database StructureDue to the restrictions of the CAP theorem, it is not always possible to do so at the same time.

Structure of a Database
The following tables are created using the SQL code:

Customer: Stores customer information such as name, contact information, personal information, and financial information.

Employee: Contains information on the employee such as name, address, email, and password.

Account: Keeps track of account information such as type, balance, account number, and status. It has a connection to both customers and staff.

Loan: Keeps track of loan information such as kind, amount, term, and status. It is linked to client accounts.

Credit_Card: Keeps track of credit card information such as card type, number, limit, and available credit.

Debit_Card: This class manages debit card information, such as the card number and PIN.

Transactions: Contains transaction information such as sender and recipient account IDs, card IDs, employee IDs, transaction name, date, amount, and status.

Database Triggers
The code includes two triggers:

CheckCreditCardAvailability: After inserting a new transaction, this trigger checks the available credit of the associated credit card and updates the transaction status as 'successful' or 'rejected' accordingly.

CheckLoanAmount: Before inserting a new loan record, this trigger verifies if the loan amount exceeds five times the average income of the associated customer. If so, it sets the loan status to 'rejected'.

Database Procedure
A stored procedure GenerateMonthlyStatements is defined to generate monthly account statements for active accounts. This procedure can be used to retrieve account data, calculate balances, and format account statements.Transactions: Records transaction details, including sender and receiver account IDs, card IDs, employee IDs, transaction name, date, amount, and status.

Database Triggers
The code includes two triggers:
CheckCreditCardAvailability: When a new transaction is inserted, this trigger checks the available credit of the linked credit card and updates the transaction status as'successful' or'rejected' as appropriate.

CheckLoanAmount: Before adding a new loan record, this trigger checks to see if the loan amount exceeds five times the linked customer's typical income. If this is the case, the loan status is changed to "rejected."

Procedure for a Database
A predefined method The GenerateMonthlyStatements function is used to create monthly account statements for active accounts. This process is useful for retrieving account information, calculating balances, and formatting account statements.
