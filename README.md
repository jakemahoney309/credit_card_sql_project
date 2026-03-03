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

## Key Findings
- ~$91M in total transaction volume, with an overall fraud rate of 4.37%.
  - Average transaction: $70.35
  - Median transaction: $47.52
- Transactions over $500 had a fraud rate exceeding 23%, compared to ≤1% for transactions below $500.
  Fraud incidence increased sharply during late-night hours (22:00–23:00), peaking near 23%, and remained elevated (~6%) until 05:00. Daytime fraud rates ranged between 0.5–1.5%.
- A small subset of merchants showed fraud rates above 20%, though they represented a limited share of total transactions.
- Customers in towns with populations under 10,000 exhibited the highest average total spend per customer ($94,590.61). Fraud rates remained relatively consistent across population sizes (4.1–4.8%).
- Wyoming had the highest average customer spend, followed by West Virginia and Arkansas.

## Insights
- Fradulent transactions are typically made at night, for large purchase amounts, and at specific merchants. Statagies for reducing fraud should priorotize monitoring transactions of this type.
- Rural markets should be targeted for growth. Customers form towns of under 10K people and from predomintly rural states show the highest average spend per customer. Fraud rates for these areas are not meaningfuly different from other locations as well, presenting no increaced risk.

## How to Run
1. Create a new SQLite database  
2. Import the CSV dataset  
3. Run `schema.sql` to create tables  
4. Run `inserts.sql` to populate tables  
5. Run `queries.sql` to generate analysis results  
