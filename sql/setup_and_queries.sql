-- Drop table if exists
IF OBJECT_ID('customers') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('loans') IS NOT NULL DROP TABLE loans;

-- Customers table
CREATE TABLE customers(
    customer_id VARCHAR(10) PRIMARY KEY,
    gender VARCHAR(10),
    married VARCHAR(5),
    dependents VARCHAR(5),
    education VARCHAR(20),
    self_employed VARCHAR(5),
    applicant_income INT,
    coapplicant_income INT,
    loan_history_flag BIT
)

-- Loans table
CREATE TABLE loans(
    loan_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    loan_amount INT,
    loan_amount_term INT,
    credit_history BIT,
    property_area VARCHAR(20),
    loan_status CHAR(1),
    defaulted CHAR(1),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- BULK INSERT CSVs

BULK INSERT customers
FROM 'F:\Data Analytics\Projects\Bank-Loan-Risk\data\customers.csv'
WITH (
    FIRST_ROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    FORMAT = 'CSV'
)

BULK INSERT loans
FROM 'F:\Data Analytics\Projects\Bank-Loan-Risk\data\loans.csv'
WITH (
    FIRST_ROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    FORMAT = 'CSV'
)

