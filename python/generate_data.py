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
