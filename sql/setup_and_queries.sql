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
    ROWTERMINATOR = '\n',
    TABLOCK,
    FORMAT = 'CSV'
)

BULK INSERT loans
FROM 'F:\Data Analytics\Projects\Bank-Loan-Risk\data\loans.csv'
WITH (
    FIRST_ROW = 2,
    FIELDTERMINATOR = ',',
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
JOIN customers c ON l.customer_id = c.customer_id

-- 6) Risk segments (gender/married/dependents)
SELECT c.gender, c.married, c.dependents,
       ROUND(100.0*SUM(CASE WHEN l.defaulted = 'Y' THEN 1 ELSE 0 END)/
       NULLIF(SUM(CASE WHEN l.loan_status ='Y' THEN 1 ELSE 0 END),0),2) AS default_pct
from loans l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.gender, c.married, c.dependents
ORDER BY default_pct DESC

-- 7) Loan term buckets & default
SELECT loan_amount_term,
    ROUND(100.0*SUM(CASE WHEN defaulted = 'Y' THEN 1 ELSE 0 END)/ 
    NULLIF(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END),0), 2) AS default_pct
FROM loans
GROUP BY loan_amount_term
ORDER BY loan_amount_term

-- 8) Top risky customers (by loan amount & default flag)
SELECT TOP 30
       l.loan_id, l.customer_id, l.loan_amount, l.loan_amount_term,
       l.credit_history, l.property_area, l.loan_status, l.defaulted,
       c.applicant_income
FROM loans l
JOIN customers c on l.customer_id = c.customer_id
WHERE l.defaulted = 'Y'
ORDER BY l.loan_amount DESC;

-- 9) Cohort: new vs repeat loans (if multiple loans per customer)
SELECT loans_count, COUNT(*) AS customers
FROM (
    SELECT customer_id, COUNT(*) AS loans_count
    FROM loans
    GROUP BY customer_id
) x
GROUP BY loans_count
ORDER BY loans_count;

-- 10) Window: rank top loan amount
SELECT TOP 20
       loan_id, customer_id, loan_amount,
       RANK() OVER (ORDER BY loan_amount DESC) AS loan_rank
FROM loans
ORDER BY loan_rank;

-- 11) Payment-risk heuristic: high loan/income ratio
SELECT TOP 30
       l.loan_id, l.customer_id, l.loan_amount, c.applicant_income,
       ROUND(CAST((l.loan_amount*1000.0) AS FLOAT) / NULLIF(c.applicant_income, 0), 2) AS loan_to_income_ration
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
ORDER BY loan_to_income_ration DESC;

-- 12) Approval rate by credit_history
SELECT credit_history,
       ROUND(100.0*SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)/COUNT(*), 2) AS approval_pct
FROM loans
GROUP BY credit_history
ORDER BY credit_history DESC;