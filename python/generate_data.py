# Generating Data from python
import pandas as pd
import numpy as np
import random
from faker import Faker
from pathlib import Path

fake = Faker()
OUT = Path("data")
OUT.mkdir(exist_ok=True)

# Parameters
N = 500
customer_ids = [f"C{str(i).zfill(4)}" for i in range (1, N+1)]
loan_ids = [f"L{str(i).zfill(4)}" for i in range (1, N+1)]

# Possible values
genders = ["Male", "Female"]
married = ["Yes", "No"]
dependents = ["0", "1", "2", "3+"]
education = ["Graduation", "Not Graduate"]
self_employed = ["Yes", "No"]
property_area = ["Urban", "Semiurban", "Rural"]
loan_terms = [120, 180, 240, 300, 360] # months
credit_hist = [0, 1]

# 1) Customers

customers = []
for cid in customer_ids:
    app_income = random.randint(1500, 30000) # PKR/month scale
    coapp_income = random.choice([0, random.randint(0, 15000)])
    customers.append({
        "customer_id": cid,
        "gender": random.choice(genders),
        "married": random.choice(married),
        "dependents": random.choice(dependents),
        "education": random.choice(education),
        "self_employed": random.choice(self_employed),
        "applicant_income": app_income,
        "coapplicant_income": coapp_income,
        "loan_history_flag": random.choice([0,1]) # extra feature
    })

customers_df = pd.DataFrame(customers)

# 2) Loans (1:1 mapping to customers for simplicity - each customers one Loan)

loans = []
for lid, cid in zip(loan_ids, customer_ids):
    # loan amount in thousands ( so 100 -> 100k)
    # base on income make realistic: loan ~ (0.5 to 0.6) * monthly in thousands
    cust = customers_df.loc[customers_df['customer_id'] == cid].iloc[0]
    base = max(50, int(np.clip(random.gauss(200, 80), 50, 700)))
    # vary by applicant income a little
    loan_amount = base
    loan_term = random.choice(loan_terms)
    credit_history = random.choices(credit_hist, weights=[0.2, 0.8])[0]
    prop = random.choices(property_area, weights=[0.5, 0.3, 0.2])[0]

    # approval chance influenced by credit_history and income
    approve_prob = 0.6 + 0.25*credit_history - (0.00001*max(0, 20000 - cust.applicant_income))
    status = "Y" if random.random() < max(0.25, min(approve_prob, 0.95)) else "N"

