--Author: Jake Mahoney
--Date: 2026-03-02
--Description: Analysis of credit card transactions and fraud rates
--Includes summaries based on 1. general overview, 2. merchants, 3. transaction size, 4. state, 5. city size, 6. time of day

--Basic Overview of Database showing data across all transactions
SELECT 
	ROUND(SUM(t.amount),2) AS total_transaction_amount,
	(SELECT sum(amount) FROM transactions WHERE is_fraud = 1) AS total_fraud_amount, 
	ROUND((SELECT sum(amount) FROM transactions WHERE is_fraud = 1)*100.0/SUM(t.amount),2) AS percent_fraud,
	COUNT(*) AS num_transactions, 
	ROUND(AVG(t.amount),2) AS average_transaction_amount, 
	ROUND(( 
		SELECT AVG(amount) 
		FROM ( 
			SELECT amount 
			FROM transactions 
			ORDER BY amount 
			LIMIT 2 - (SELECT COUNT(*) FROM transactions) % 2
			OFFSET (SELECT (COUNT(*) - 1)/2 FROM transactions)
			) 
	) ,2) AS median_transaction_amount, 
	(SELECT COUNT(*) FROM customers) AS num_customers, 
	ROUND(AVG(cc.customer_total),2) AS average_total_per_customer, 
	ROUND (AVG(cc.num_transactions),2) AS average_num_transactions_per_customer 
FROM transactions t 
JOIN cards ca 
	ON ca.card_id = t.card_id 
JOIN ( 
	SELECT 
		ca.customer_id, 
		SUM(t.amount) AS customer_total, 
		COUNT(*) AS num_transactions 
	FROM transactions t 
	JOIN cards ca 
		ON ca.card_id = t.card_id 
	GROUP BY ca.customer_id
	) cc 
	ON cc.customer_id = ca.customer_id;
	
--Description: summary of fraud grouped by merchant, 
--shows number of transactions, number fraudulent transactions, total transaction amount, fraudulent transaction amount, and percentages by count and amount
SELECT 
	m.merch_name,
	COUNT(*) AS num_transactions,
	COUNT(CASE WHEN t.is_fraud=1 THEN 1 END) AS num_fraudulent,
	(COUNT(CASE WHEN t.is_fraud=1  THEN 1 END) * 100.0 / COUNT(*) )  AS percent_num_fraudulent,
	SUM(t.amount) AS total_transaction_amount,
	SUM(CASE WHEN t.is_fraud=1 THEN t.amount ELSE 0 END) AS total_fraudulent_transaction_amount,
	SUM(CASE WHEN t.is_fraud=1 THEN t.amount ELSE 0 END) *100.0 /  SUM(t.amount) AS percent_amount_fraudulent
FROM transactions t
JOIN merchants m
	ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_id
ORDER BY percent_amount_fraudulent DESC;

--Shows fraud amounts and rates grouped by transaction size
SELECT 
	CASE
		WHEN amount < 10 THEN '<10' 
        WHEN amount <= 50 THEN '10-49' 
        WHEN amount <=100 THEN '50-99' 
        WHEN amount <= 500 THEN '100-500' 
        WHEN amount <= 1000 THEN '500-1000' 
		WHEN amount > 1000 THEN '>1000'
	END AS transaction_size,
	SUM(CASE WHEN is_fraud=1 THEN 1 ELSE 0 END) AS num_fraudulent_transactions,
	COUNT(*) AS num_transaction,
	SUM(CASE WHEN is_fraud=1 THEN 1 ELSE 0 END)*100.0/COUNT(*)  AS percent_fraudulent
FROM transactions 
GROUP BY transaction_size
ORDER BY 
    CASE 
        WHEN transaction_size = '<10' THEN 1
        WHEN transaction_size = '10-49' THEN 2
        WHEN transaction_size = '50-99' THEN 3
		WHEN transaction_size = '100-500' THEN 4
		WHEN transaction_size = '500-1000' THEN 5
		WHEN transaction_size = '>1000' THEN 6
    END;
	
--Shows which states have the highest spending customers and gives stats on fraud rates in the state
--States with fewer than 10 customers are excluded as there are not enough customers to find meaningful trends
SELECT
	cu.state,
	COUNT(DISTINCT cu.customer_id) AS num_customers,
	ROUND(SUM(t.amount),2) AS total_spent,
	ROUND(SUM(t.amount)/COUNT(DISTINCT cu.customer_id),2) AS average_spent_per_customer,
	ROUND(SUM(CASE WHEN is_fraud=1 THEN t.amount ELSE 0 END),2) AS total_fraud,
	ROUND(SUM(CASE WHEN is_fraud=1 THEN t.amount ELSE 0 END) * 100.0/ SUM(t.amount),2) AS percent_fraud
FROM customers cu
JOIN cards ca
	ON ca.customer_id = cu.customer_id
JOIN transactions t
	ON t.card_id = ca.card_id
GROUP BY cu.state
HAVING COUNT(DISTINCT cu.customer_id) > 10
ORDER BY average_spent_per_customer DESC;

--Total spend and fraud rates grouped by city population
SELECT
	CASE
		WHEN cu.city_pop < 10000 THEN 'Under 10,000'
		WHEN cu.city_pop <= 50000 THEN '10,000-50,000'
		WHEN cu.city_pop <= 250000 THEN '50,000-250,000'
		WHEN cu.city_pop <= 1000000 THEN '250,000-1,000,000'
		ELSE 'OVER 1,000,000'
	END AS city_population,
	SUM(t.amount) AS total_spend,
	COUNT(DISTINCT cu.customer_id) AS num_customers,
	ROUND(SUM(t.amount)/COUNT(DISTINCT cu.customer_id),2) AS average_spend_per_customer,
	ROUND(SUM(CASE WHEN t.is_fraud=1 THEN t.amount ELSE 0 END),2) AS total_fraud,
	SUM(CASE WHEN t.is_fraud=1 THEN t.amount ELSE 0 END) *100.0 / SUM(t.amount) AS percent_fraud
FROM customers cu
JOIN cards ca
	ON ca.customer_id = cu.customer_id
JOIN transactions t
	ON ca.card_id = t.card_id
GROUP BY city_population
ORDER BY 
    CASE
        WHEN city_population = 'Under 10,000' THEN 1
        WHEN city_population = '10,000-50,000' THEN 2
        WHEN city_population = '50,000-250,000' THEN 3
        WHEN city_population = '250,000-1,000,000' THEN 4
        ELSE 5
    END;

--Total spend and fraud rates grouped by hour of the day 
SELECT
	CAST(strftime ('%H', trans_datetime) AS INTEGER) AS hour_of_day,
	COUNT(*) AS num_transactions,
	SUM(is_fraud) AS num_fraudulent_transactions,
	SUM(is_fraud)*100.0/COUNT(*) AS percent_num_fraudulent,
	SUM(amount) AS total_spend,
	SUM(CASE WHEN is_fraud=1 THEN amount ELSE 0 END) AS total_fraud,
	SUM(CASE WHEN is_fraud=1 THEN amount ELSE 0 END) *100.0/SUM(amount) AS percent_total_fraud
FROM transactions 
GROUP BY hour_of_day
ORDER BY hour_of_day;
