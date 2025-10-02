import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ==================
# 1. Load Data
# ==================

customers = pd.read_csv("../data/customers.csv")
loans = pd.read_csv("../data/loans.csv")

print("Customers shape:", customers.shape)
print("Loans shape:", loans.shape)

# ==================
# 2. Clean Data
# ==================
# Standardize column names (lowercase)
customers.columns = customers.columns.str.lower()
loans.columns = loans.columns.str.lower()

# Ensure numeric columns
loans['loan_amount'] = pd.to_numeric(loans['loan_amount'], errors = 'coerce')
customers['applicant_income'] = pd.to_numeric(customers['applicant_income'], errors = 'coerce')

# Merge
df = loans.merge(customers, on='customer_id', how='left')

print ("Merged dataset shape:", df.shape)

