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

# ==================
# 3. KPIs 
# ==================
total_loans = len(df)
approval_rate = round((df['loan_status'].eq('Y').mean())*100,2)
default_rate = round((df.query("loan_status == 'Y'")['defaulted'].eq('Y').mean())*100,2)
avg_loan = df['loan_amount'].mean()
avg_income = df['applicant_income'].mean()

print('Total loans:', total_loans)
print('Approval rate %:', approval_rate)
print('Default rate % (approved only):', default_rate)
print('Average loan:', round(avg_loan, 2))
print('Average income:', round(avg_income, 2))


# ==================
# 4. Group Insights
# ==================

by_property = df.groupby('property_area')['loan_status'].apply(lambda x: (x=='Y').mean()*100)
print("\nApproval rate by property area:\n", by_property)

by_education = df.groupby('education')['defaulted'].apply(lambda x: (x=='Y').mean()*100)
print("\nDefault rate by education:\n", by_education)


