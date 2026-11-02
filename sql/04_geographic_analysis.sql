
USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Script: 04_geographic_analysis.sql
-- Purpose: Analyse fraud-labelled transactions by country.
-- Source table: bank_transactions
-- Note: The dataset is synthetic. Country-level associations
-- do not establish real-world fraud risk.


-- 1. Fraud-labelled transaction counts by country
SELECT
    country,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(transaction_amount), 2)
        AS fraud_labelled_transaction_value,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM bank_transactions
         WHERE is_fraud = 1),
        2
    ) AS percentage_of_all_fraud_labelled_transactions
FROM bank_transactions
WHERE is_fraud = 1
GROUP BY country
ORDER BY fraud_transactions DESC;


-- 2. Fraud rate by country
SELECT
    country,
    COUNT(*) AS total_transactions,
    SUM(is_fraud = 1) AS fraud_transactions,
    ROUND(
        100.0 * SUM(is_fraud = 1) / COUNT(*),
        2
    ) AS fraud_rate_pct
FROM bank_transactions
GROUP BY country
ORDER BY fraud_rate_pct DESC;
