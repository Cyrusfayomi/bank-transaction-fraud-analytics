
USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Script: 06_transaction_behaviour_analysis.sql
-- Purpose: Analyse fraud rates by device, transaction
--          location type, and transaction timing.
-- Source table: bank_transactions
-- Note: The dataset is synthetic; associations are not causal.


-- 1. Fraud analysis by device type
SELECT
    device_type,
    COUNT(*) AS total_transactions,
    SUM(is_fraud = 1) AS fraud_transactions,
    ROUND(
        100.0 * SUM(is_fraud = 1) / COUNT(*),
        2
    ) AS fraud_rate_pct
FROM bank_transactions
GROUP BY device_type
ORDER BY fraud_rate_pct DESC;


-- 2. Domestic versus international transactions
SELECT
    is_international,
    COUNT(*) AS total_transactions,
    SUM(is_fraud = 1) AS fraud_transactions,
    ROUND(
        100.0 * SUM(is_fraud = 1) / COUNT(*),
        2
    ) AS fraud_rate_pct,
    ROUND(
        SUM(CASE
            WHEN is_fraud = 1
            THEN transaction_amount
            ELSE 0
        END),
        2
    ) AS fraud_labelled_transaction_value
FROM bank_transactions
GROUP BY is_international
ORDER BY is_international;


-- 3. Fraud rates by nighttime and weekend flags
SELECT
    is_night_transaction,
    is_weekend,
    COUNT(*) AS total_transactions,
    SUM(is_fraud = 1) AS fraud_transactions,
    ROUND(
        100.0 * SUM(is_fraud = 1) / COUNT(*),
        2
    ) AS fraud_rate_pct
FROM bank_transactions
GROUP BY
    is_night_transaction,
    is_weekend
ORDER BY
    is_night_transaction,
    is_weekend;
