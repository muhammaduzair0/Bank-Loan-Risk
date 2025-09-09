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

