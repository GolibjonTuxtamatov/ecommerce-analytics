
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:golibjon@localhost:5432/ecommerce_db')

query = """
    SELECT order_purchase_timestamp, order_id
    FROM orders
    WHERE order_status = 'delivered';
"""

orders = pd.read_sql(query, engine)
orders['order_purchase_timestamp'] = pd.to_datetime(orders['order_purchase_timestamp'])