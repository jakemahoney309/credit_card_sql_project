-- inserts.sql
-- Author: Jake Mahoney
-- Date: 2026-02-27
-- Description: Populates tables with initial data from credit_card_transactions table.

-- Insert into customer table
INSERT INTO customers(first, last, sex, dob, street, city, state, zip, city_pop, job,latitude, longitude)
SELECT DISTINCT first, last, gender AS sex, dob, street, city, state, zip, city_pop, job, lat AS latitude, long AS longitude
FROM credit_card_transactions;

-- Insert into cards table 
-- Join with customers to assign customer_id to each card as foreign key
INSERT INTO cards(card_num, customer_id)
SELECT DISTINCT t.cc_num, c.customer_id
FROM credit_card_transactions t
JOIN customers c
  ON t.first = c.first
  AND t.last = c.last
  AND t.gender = c.sex
  AND t.dob = c.dob
  AND t.street = c.street
  AND t.city = c.city;
  
 -- Insert into merchant table 
INSERT INTO merchants(merch_name, category)
SELECT DISTINCT merchant AS merch_name, category
FROM credit_card_transactions;

-- Insert into transactions table 
-- Join with merchants to assign merchant_id as foreign key
-- Join with cards to assign card_id as foreign key
INSERT INTO transactions(amount, trans_datetime, is_fraud, merchant_id, card_id)
SELECT t.amt, t.trans_date_trans_time AS trans_datetime, t.is_fraud, m.merchant_id, ca.card_id
FROM credit_card_transactions t
JOIN merchants m
	ON t.merchant = m.merch_name
	AND t.category=m.category
JOIN cards ca
	ON t.cc_num = ca.card_num;