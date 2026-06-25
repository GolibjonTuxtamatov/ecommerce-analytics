import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql://postgres:golibjon@localhost:5432/ecommerce_db")


#Count of total orders
query = """
        SELECT COUNT(*) FROM orders
    """

result = pd.read_sql(query,engine)

print(result)


