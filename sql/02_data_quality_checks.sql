
USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Script: 02_data_quality_checks.sql
-- Purpose: Investigate data consistency and document observations.
-- Note: These queries inspect data; they do not modify records.


-- 1. Check fraud labels against fraud types
SELECT
    is_fraud,
    fraud_type,
    COUNT(*) AS transaction_count
FROM bank_transactions
GROUP BY is_fraud, fraud_type
ORDER BY is_fraud, transaction_count DESC;


-- 2. Inspect the observed nighttime flag pattern
SELECT
    hour_of_day,
    is_night_transaction,
    COUNT(*) AS transaction_count
FROM bank_transactions
GROUP BY hour_of_day, is_night_transaction
ORDER BY hour_of_day, is_night_transaction;


-- 3. Check distance and elapsed-time ranges
SELECT
    MIN(distance_from_home_km) AS minimum_distance_km,
    MAX(distance_from_home_km) AS maximum_distance_km,
    MIN(time_since_last_txn_hrs) AS minimum_elapsed_hours,
    MAX(time_since_last_txn_hrs) AS maximum_elapsed_hours
FROM bank_transactions;


-- 4. Check monetary and account-age ranges
SELECT
    MIN(transaction_amount) AS minimum_transaction_amount,
    MAX(transaction_amount) AS maximum_transaction_amount,
    MIN(account_balance) AS minimum_account_balance,
    MAX(account_balance) AS maximum_account_balance,
    MIN(account_age_years) AS minimum_account_age_years,
    MAX(account_age_years) AS maximum_account_age_years
FROM bank_transactions;


-- 5. Record the number of distinct categories
SELECT
    COUNT(DISTINCT country) AS countries,
    COUNT(DISTINCT merchant_category) AS merchant_categories,
    COUNT(DISTINCT payment_method) AS payment_methods,
    COUNT(DISTINCT device_type) AS device_types,
    COUNT(DISTINCT fraud_type) AS fraud_type_values
FROM bank_transactions;
