
USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Script: 03_fraud_overview.sql
-- Purpose: Summarise transaction volume, fraud frequency,
--          fraud rate and transaction amounts.
-- Source table: bank_transactions


-- 1. Overall fraud overview
SELECT
    COUNT(*) AS total_transactions,
    SUM(is_fraud = 1) AS fraud_transactions,
    SUM(is_fraud = 0) AS non_fraud_transactions,
    ROUND(100.0 * SUM(is_fraud = 1) / COUNT(*), 2)
        AS fraud_rate_pct,
    ROUND(SUM(transaction_amount), 2)
        AS total_transaction_value,
    ROUND(
        SUM(CASE WHEN is_fraud = 1
            THEN transaction_amount ELSE 0 END),
        2
    ) AS fraud_labelled_transaction_value
FROM bank_transactions;


-- 2. Fraud type distribution
SELECT
    fraud_type,
    COUNT(*) AS transaction_count,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM bank_transactions
         WHERE is_fraud = 1),
        2
    ) AS percentage_of_fraud_labelled_transactions
FROM bank_transactions
WHERE is_fraud = 1
GROUP BY fraud_type
ORDER BY transaction_count DESC;


-- 3. Transaction amounts by fraud label
SELECT
    is_fraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(transaction_amount), 2) AS average_amount,
    MIN(transaction_amount) AS minimum_amount,
    MAX(transaction_amount) AS maximum_amount,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM bank_transactions
GROUP BY is_fraud
ORDER BY is_fraud;
