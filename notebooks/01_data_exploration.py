
import pandas as pd


# Datasetlarni yuklaymiz
customers = pd.read_csv('../data/olist_customers_dataset.csv')
orders = pd.read_csv('../data/olist_orders_dataset.csv')
order_items = pd.read_csv('../data/olist_order_items_dataset.csv')
payments = pd.read_csv('../data/olist_order_payments_dataset.csv')
products = pd.read_csv('../data/olist_products_dataset.csv')
sellers = pd.read_csv('../data/olist_sellers_dataset.csv')
reviews = pd.read_csv('../data/olist_order_reviews_dataset.csv')

#customers
print("Info customers")
customers.info()
customers.isnull().sum()
customers.duplicated().sum()

#cleaning products table
products.isnull().sum()
products.dtypes

products["product_category_name"] = products["product_category_name"].fillna("no name category")

prod_cols = ['product_photos_qty','product_name_lenght','product_description_lenght','product_weight_g', 'product_length_cm', 'product_height_cm', 'product_width_cm']
products[prod_cols] = products[prod_cols].fillna(0)

#transfrom and cleaning orders table
print("Info orders")
orders.info()
orders.duplicated().sum()


orders["order_purchase_timestamp"] = pd.to_datetime(orders["order_purchase_timestamp"],errors="coerce")
orders["order_approved_at"] = pd.to_datetime(orders["order_approved_at"],errors="coerce")
orders["order_delivered_carrier_date"] = pd.to_datetime(orders["order_delivered_carrier_date"],errors="coerce")
orders["order_delivered_customer_date"] = pd.to_datetime(orders["order_delivered_customer_date"],errors="coerce")
orders["order_estimated_delivery_date"] = pd.to_datetime(orders["order_estimated_delivery_date"],errors="coerce")   

#cleaning order_items table
order_items.info()
order_items.dtypes
order_items.isnull().sum()

order_items["shipping_limit_date"] = pd.to_datetime(order_items["shipping_limit_date"],errors="coerce")

#cleaning payments table
payments.info()
payments.dtypes
payments.isnull().sum()

#cleaning sellers table
sellers.info()
sellers.dtypes
sellers.isnull().sum()

#cleaning reviewes table
reviews.info()
reviews.dtypes
reviews.isnull().sum()

reviews["review_creation_date"] = pd.to_datetime(reviews["review_creation_date"],errors="coerce")
reviews["review_answer_timestamp"] = pd.to_datetime(reviews["review_answer_timestamp"],errors="coerce")

reviews['review_comment_title'] = reviews["review_comment_title"].fillna("no title")
reviews['review_comment_message'] = reviews["review_comment_message"].fillna("no message")


#writing clean data
customers.to_csv("../data/cleaned_data/clean_customers.csv")
products.to_csv("../data/cleaned_data/clean_products.csv")
orders.to_csv("../data/cleaned_data/clean_orders.csv")
order_items.to_csv("../data/cleaned_data/clean_order_items.csv")
payments.to_csv("../data/cleaned_data/clean_payments.csv")
sellers.to_csv("../data/cleaned_data/clean_seller.csv")
reviews.to_csv("../data/cleaned_data/clean_reviews.csv")