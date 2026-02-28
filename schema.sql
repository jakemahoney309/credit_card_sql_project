-- schema.sql
-- Author: Jake Mahoney
-- Date: 2026-02-27
-- Description: Database schema for credit card project
-- 
-- Relationships:
--   cards.customer_id -> customers.customer_id
--   transactions.card_id -> cards.card_id
--   transactions.merchant_id -> merchants.merchant_id

-- Table: customers
-- Purpose: stores information for each customer
-- Primary Key: customer_id
-- Referenced by cards.customer_id as FK
CREATE TABLE customers(
	customer_id INTEGER PRIMARY KEY AUTOINCREMENT, 
	first TEXT, 
	last TEXT, 
	sex TEXT, 
	dob DATE, 
	street TEXT,
	city TEXT, 
	state TEXT, 
	zip INTEGER, 
	city_pop INTEGER, 
	job TEXT, 
	latitude REAL, 
	longitude REAL
);

-- Table: cards
-- Purpose: stores information for each card
-- Primary Key: card_id
-- Foreign Key: customer_id -> customers.customer_id
-- Referenced by transaction.card_id as FK
CREATE TABLE cards(
	card_id INTEGER PRIMARY KEY AUTOINCREMENT,
	card_num TEXT,
	customer_id INTEGER,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Table: merchants
-- Purpose: stores information for each merchant
-- Primary Key: merchant_id
-- Referenced by transactions.merchant_id as FK
CREATE TABLE merchants(
	merchant_id INTEGER PRIMARY KEY AUTOINCREMENT,
	merch_name TEXT,
	category TEXT
);

-- Table: transactions
-- Purpose: stores information for each transaction
-- Primary Key: transaction_id
-- Foreign Keys: merchant_id -> merchants.merchant_id | card_id -> cards.card_id
CREATE TABLE transactions(
	transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
	amount REAL, 
	trans_datetime DATETIME,
	is_fraud INTEGER,
	merchant_id INTEGER, 
	card_id INTEGER,
	FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id),
	FOREIGN KEY (card_id) REFERENCES cards(card_id)
	);