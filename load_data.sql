SET GLOBAL local_infile = 1;

-- 1. olist_customers_dataset.csv
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) ,
    customer_zip_code_prefix INT ,
    customer_city VARCHAR(100) ,
    customer_state CHAR(2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. olist_geolocation_dataset.csv
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT ,
    geolocation_lat DECIMAL(10, 8) ,
    geolocation_lng DECIMAL(11, 8) ,
    geolocation_city VARCHAR(100) ,
    geolocation_state CHAR(2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. olist_order_items_dataset.csv
CREATE TABLE order_items (
    order_id VARCHAR(50) ,
    order_item_id INT ,
    product_id VARCHAR(50) ,
    seller_id VARCHAR(50) ,
    shipping_limit_date DATETIME ,
    price DECIMAL(10, 2) ,
    freight_value DECIMAL(10, 2) ,
    PRIMARY KEY (order_id, order_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. olist_order_payments_dataset.csv
CREATE TABLE order_payments (
    order_id VARCHAR(50) ,
    payment_sequential INT ,
    payment_type VARCHAR(50) ,
    payment_installments INT ,
    payment_value DECIMAL(10, 2) ,
    PRIMARY KEY (order_id, payment_sequential)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. olist_order_reviews_dataset.csv
CREATE TABLE order_reviews (
    review_id VARCHAR(50) ,
    order_id VARCHAR(50) ,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME ,
    review_answer_timestamp DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. olist_orders_dataset.csv
CREATE TABLE olist_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) ,
    order_status VARCHAR(50) ,
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. olist_products_dataset.csv
CREATE TABLE olist_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. olist_sellers_dataset.csv
CREATE TABLE olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT ,
    seller_city VARCHAR(100) ,
    seller_state CHAR(2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. product_category_name_translation.csv
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/hp/DataGripProjects/Olist_dataset_cleaning_and_analysis/dataset/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;