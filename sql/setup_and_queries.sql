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

