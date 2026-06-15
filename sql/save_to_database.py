import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql://postgres:golibjon@localhost:5432/ecommerce_db")

customers = pd.read_csv("../data/cleaned_data/clean_customers.csv")
products = pd.read_csv("../data/cleaned_data/clean_products.csv")
orders = pd.read_csv("../data/cleaned_data/clean_orders.csv")
order_items = pd.read_csv("../data/cleaned_data/clean_order_items.csv")
payments = pd.read_csv("../data/cleaned_data/clean_payments.csv")
sellers = pd.read_csv("../data/cleaned_data/clean_seller.csv")
reviews = pd.read_csv("../data/cleaned_data/clean_reviews.csv")

customers.to_sql(
    name = 'customers',
    con = engine,
    if_exists = 'append',
    index = False
)

orders.to_sql(
    name='orders',
    con=engine,
    if_exists='append',
    index=False
)

order_items.to_sql(
    name='order_items',
    con=engine,
    if_exists='append',
    index=False
)

payments.to_sql(
    name='payments',
    con=engine,
    if_exists='append',
    index=False
)

products.to_sql(
    name='products',
    con=engine, 
    if_exists='append', 
    index=False
)

sellers.to_sql(
    name='sellers', 
    con=engine, 
    if_exists='append',
    index=False
)

reviews.to_sql(
    name='reviews', 
    con=engine, 
    if_exists='append', 
    index=False
)

engine.dispose()