
USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Script: 05_payment_merchant_analysis.sql
-- Purpose: Compare fraud rates across payment methods
--          and merchant categories.
-- Source table: bank_transactions
-- Note: This dataset is synthetic.


-- 1. Fraud analysis by payment method
SELECT
    payment_method,
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
GROUP BY payment_method
ORDER BY fraud_rate_pct DESC;


-- 2. Fraud analysis by merchant category
SELECT
    merchant_category,
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
GROUP BY merchant_category
ORDER BY fraud_rate_pct DESC;
