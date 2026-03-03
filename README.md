# Credit Card SQL Project

**Author:** Jake Mahoney  
**Date:** 2026-03-03  

## Description
This project creates a normalized relational database from a credit card transactions dataset and analyzes trends in spending and fraud.  

- `schema.sql` creates the tables  
- `inserts.sql` populates the tables with data from the original CSV dataset  
- `queries.sql` contains SQL queries to analyze transactions and fraud by location, time, transaction size, merchant, and population

### Analysis Includes
- Overview of transactions and fraud  
- Fraud by individual merchants  
- Fraud by transaction size  
- Customer spending and fraud by state  
- Customer spending and fraud by city population  
- Spending and fraud by hour of day  

## Files
- `schema.sql` – CREATE TABLE statements  
- `inserts.sql` – Populates tables with initial data  
- `queries.sql` – SQL queries for analysis  

## Datasource
- Kaggle dataset: [Credit Card Transactions Dataset](https://www.kaggle.com/datasets/priyamchoksi/credit-card-transactions-dataset)  
- CSV contains ~1.3 million transactions  

## Database Schema
- **customers**: Stores customer information  
- **cards**: Stores credit card info (linked to customers)  
- **merchants**: Stores merchant info  
- **transactions**: Stores transaction info (linked to cards and merchants)  

Referential relationships:

- `cards.customer_id → customers.customer_id`  
- `transactions.card_id → cards.card_id`  
- `transactions.merchant_id → merchants.merchant_id`  

## How to Run
1. Create a new SQLite database  
2. Import the CSV dataset  
3. Run `schema.sql` to create tables  
4. Run `inserts.sql` to populate tables  
5. Run `queries.sql` to generate analysis results  
