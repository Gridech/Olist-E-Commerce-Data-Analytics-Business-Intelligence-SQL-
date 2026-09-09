# Olist-E-Commerce-Data-Analytics-Business-Intelligence-SQL-

This repository contains a comprehensive **Exploratory Data Analysis (EDA)** and business intelligence exploration leveraging the **Olist Brazilian E-Commerce Dataset**. The primary focus of this project is to extract actionable business insights, calculate critical KPIs, and analyze sales performance using optimized SQL queries (including Joins, Common Table Expressions (CTEs), and Window Functions).

## 📊 Project Overview
Olist is the largest department store marketplace in Brazil. By analyzing over 100k orders spanning from 2016 to 2018, this project establishes a robust analytical layer to dissect high-level business performance, temporal seasonality, purchasing habits, and value distribution.

## 🔑 Core Business KPIs Addressed
The SQL scripts in this repository automatically calculate essential performance metrics:
* **Activity Volume:** Total order volume, total unique customers, and catalog product counts.
* **Financial Performance:** Global net revenue (excluding canceled/unavailable orders), Average Order Value (**AOV**), and Average Revenue Per User (**ARPU**).
* **Customer Behavior:** Average number of items per order and purchase frequency per customer.

## 📈 Temporal Analysis & Seasonality
To help optimize supply chains and marketing campaigns, specific queries evaluate time-based performance metrics:
* **Revenue Trends:** Revenue distribution analyzed daily (day of the week), weekly, and monthly.
* **Historical Peaks:** Identification of the single highest revenue-generating month in the dataset.
* **Advanced Partitioning (CTEs & Window Functions):**
  * The highest revenue-generating day discovered for every single month.
  * The peak sales month (highest order volume) isolated for each individual year.
  * The highest order volume day identified for each month.
* **Traffic & Engagement:** Identification of the absolute busiest day of the week and the peak ordering hours.

## 🎯 Advanced Order Value Segmentation
Using cumulative distribution (`CUME_DIST()`) and conditional logic, a detailed query segments orders by financial weight to understand customer tiers:
* **Standard / Low Value:** Orders sitting below the median (50th percentile).
* **Above Average:** Orders ranging from the 50th up to the 75th percentile.
* **Premium Orders:** High-value orders sitting at or above the 75th percentile.
* **High-Value Outliers:** Elite orders with a basket value equal to or greater than **500 R\$**.
