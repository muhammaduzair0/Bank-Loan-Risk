# Generating Data from python
import pandas as pd
import numpy as np
import random
from faker import Faker
from pathlib import Path

fake = Faker()
OUT = Path("data")
OUT.mkdir(exist_ok=True)

