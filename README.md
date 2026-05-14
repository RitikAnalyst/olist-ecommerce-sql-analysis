# Olist E-Commerce SQL Analysis


A SQL-based exploratory analysis of the **Olist Brazilian E-Commerce dataset**, covering revenue 
trends, customer behaviour, product performance, seller insights, logistics, and payment 
patterns — using PostgreSQL.--
##  Dataset

**Source:** [Olist E-Commerce Public Dataset — Kaggle]
(https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
The dataset contains real anonymised orders from Olist, Brazil's largest department store 
marketplace, spanning **2016–2018**.
### Tables Used
| Table | Description |
|---|---|
| `orders` | Order status, timestamps, delivery dates |
| `order_items` | Products, sellers, prices per order |
| `customers` | Customer ID, city, state |
| `sellers` | Seller ID, city, state |
| `products` | Product ID, category name |
| `product_category_translation` | Portuguese → English category names |
| `order_reviews` | Review score, review ID per order |
| `order_payments` | Payment type, value, installments |--
## Objective

Answer 20 real business questions across 6 analysis areas using SQL — mimicking the kind of ad
hoc analysis a Data Analyst would perform for an e-commerce business.--
##  Analysis Areas & Queries

### Revenue & Orders (Q1–Q4)
| # | Business Question |
|---|---|
| Q1 | What is the total revenue and number of delivered orders? |
| Q2 | How has revenue changed month over month? |
| Q3 | How many orders are in each status? What revenue is at risk? |
| Q4 | Which specific days generated the most revenue? |
### Customer Analysis (Q5–Q8)
| # | Business Question |
|---|---|
| Q5 | How many customers placed more than one order? |
| Q6 | Which Brazilian states have the most customers and highest spend? |
| Q7 | Which cities generate the most orders? |
| Q8 | Segment customers into High / Mid / Low value based on total spend *(RFM-lite)* |
### Product & Category Analysis (Q9–Q12)
| # | Business Question |
|---|---|
| Q9 | Which product categories generate the most revenue? |
| Q10 | Which products have the most reviews and what is their average score? |
| Q11 | Which categories have the best and worst customer satisfaction? |
| Q12 | What is the price range and median price per category? |
### Seller Analysis (Q13–Q16)
| # | Business Question |
|---|---|
| Q13 | Who are the top-performing sellers on the platform? |
| Q14 | Which states have the most active sellers and highest sales? |
| Q15 | Which sellers have the best and worst customer ratings? |
| Q16 | Rank all sellers by revenue within their state *(Window Function)* |
### Logistics & Delivery (Q17–Q18)
| # | Business Question |
|---|---|
| Q17 | Which states experience the fastest and slowest delivery times? |
| Q18 | What percentage of orders were delivered after the estimated date? |
### Payments & Satisfaction (Q19–Q20)
| # | Business Question |
|---|---|
| Q19 | What payment methods do customers prefer? What is the average installment count? |
| Q20 | Do faster deliveries lead to better review scores? *(Delivery vs Rating correlation)* |--
## SQL Concepts Used
- `JOIN` (multi-table joins across 3–4 tables)- `GROUP BY`, `HAVING`, `ORDER BY`- `WHERE` filtering on status and NULL values- `DATE_TRUNC`, `DATE_PART`, `DATE()` for time-based analysis
- `ROUND`, `AVG`, `SUM`, `COUNT`, `MIN`, `MAX`- `PERCENTILE_CONT` for median calculation- `CASE WHEN` for conditional logic and segmentation- **CTEs** (`WITH` clause) for readable multi-step queries- **Window Functions** — `RANK() OVER (PARTITION BY ... ORDER BY ...)`--
##  How to Run

1. Download the Olist dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian
ecommerce)
2. Set up a **PostgreSQL** database
3. Import the CSV files into their respective tables
4. Open `Olist_Ecommerce_Analysis.sql` in **pgAdmin**, **DBeaver**, or the `psql` shell
5. Run queries individually or all at once--
## Author
**Ritik Singh**  
Aspiring Data Analyst | Python · SQL · Pandas · Matplotlib  
�
�
 [github.com/RitikAnalyst](https://github.com/RitikAnalyst)
