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
    ROWTERMINATOR = '\n',
    TABLOCK,
    FORMAT = 'CSV'
)

BULK INSERT loans
FROM 'F:\Data Analytics\Projects\Bank-Loan-Risk\data\loans.csv'
WITH (
    FIRST_ROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    ROWTERMINATOR = '\n',
    TABLOCK,
    FORMAT = 'CSV'
)

-- Quick Counts

SELECT 'Customers' AS what, COUNT(*) AS cnt FROM customers;
SELECT 'Loans' AS what, COUNT(*) AS cnt FROM loans;

-- ANALYTICAL QUERIES

-- 1) Approval Rate
SELECT ROUND(100.0*SUM(CASE WHEN loan_status='Y' THEN 1 ELSE 0 END) / 
    COUNT(*),2) AS approval_pct
FROM loans;

-- 2) Default Rate (of approved loans)
SELECT ROUND(100.0*SUM(CASE WHEN defaulted = 'Y' THEN 1 ELSE 0 END) / 
    NULLIF(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END),0),2) AS default_pct_of_approved 
FROM loans;

-- 3) Approval by Property Area
SELECT property_area,
       ROUND(100.0*SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) /COUNT(*),2) AS approval_pct
FROM loans
GROUP BY property_area
ORDER BY approval_pct DESC;

-- 4) Default by Education
SELECT c.education,
       ROUND(
            100.0 * SUM(CASE WHEN l.defaulted = 'Y' THEN 1 ELSE 0 END) /
            NULLIF(SUM(CASE WHEN l.loan_status = 'Y' THEN 1 ELSE 0 END),0),
        2) AS default_pct
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.education
ORDER BY default_pct DESC;

-- 5) Avg Loan and avg applicant income
SELECT ROUND(AVG(l.loan_amount),2) AS avg_loan_thousands,
        ROUND(AVG(c.applicant_income), 2) AS avg_income
FROM loans l
JOIN customers c ON l.customer_id = c.customer_idJOIN customers c ON l.customer_id = c.customer_id

