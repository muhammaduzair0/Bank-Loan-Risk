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

