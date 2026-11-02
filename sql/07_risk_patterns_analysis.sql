
USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Script: 07_risk_patterns_analysis.sql
-- Purpose: Examine fraud rates by failed attempts
--          and identify monthly fraud trends.
-- Source table: bank_transactions
-- Note: The dataset is synthetic.


-- 1. Fraud analysis by number of failed attempts
SELECT
    CASE
        WHEN failed_attempts = 0 THEN '0 attempts'
        WHEN failed_attempts = 1 THEN '1 attempt'
        WHEN failed_attempts = 2 THEN '2 attempts'
        ELSE '3+ attempts'
    END AS failed_attempts_group,
    COUNT(*) AS total_transactions,
    SUM(is_fraud = 1) AS fraud_transactions,
    ROUND(
        100.0 * SUM(is_fraud = 1) / COUNT(*),
        2
    ) AS fraud_rate_pct
FROM bank_transactions
GROUP BY
    CASE
        WHEN failed_attempts = 0 THEN '0 attempts'
        WHEN failed_attempts = 1 THEN '1 attempt'
        WHEN failed_attempts = 2 THEN '2 attempts'
        ELSE '3+ attempts'
    END
ORDER BY
    CASE
        WHEN failed_attempts = 0 THEN 1
        WHEN failed_attempts = 1 THEN 2
        WHEN failed_attempts = 2 THEN 3
        ELSE 4
    END;


-- 2. Monthly fraud trends
SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    DATE_FORMAT(transaction_date, '%Y-%m') AS year_month,
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
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date),
    DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY
    transaction_year,
    transaction_month;
