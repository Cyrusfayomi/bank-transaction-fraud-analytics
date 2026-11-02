USE bank_fraud_analytics;

-- Project: Bank Transaction Fraud Analytics
-- Purpose: Validate dataset completeness and consistency
-- Source table: bank_transactions
-- Dataset size: 1,000,000 transactions



-- 1. Confirm dataset size and date coverage
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids,
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date,
    COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m'))
        AS distinct_months,
    SUM(is_fraud = 1) AS fraud_transactions,
    SUM(is_fraud = 0) AS non_fraud_transactions
FROM bank_transactions;


-- 2. Check missing values and invalid transaction amounts
SELECT
    COUNT(*) AS total_rows,
    SUM(transaction_id IS NULL OR TRIM(transaction_id) = '')
        AS missing_transaction_ids,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '')
        AS missing_customer_ids,
    SUM(transaction_date IS NULL) AS missing_dates,
    SUM(transaction_amount IS NULL) AS missing_amounts,
    SUM(transaction_amount <= 0) AS non_positive_amounts,
    SUM(is_fraud IS NULL OR is_fraud NOT IN (0, 1))
        AS invalid_fraud_flags
FROM bank_transactions;


-- 3. Check duplicate transaction IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids,
    COUNT(*) - COUNT(DISTINCT transaction_id)
        AS duplicate_transaction_ids
FROM bank_transactions;


-- 4. Check valid binary indicator values
SELECT
    'is_fraud' AS column_name,
    COUNT(DISTINCT is_fraud) AS distinct_values,
    SUM(is_fraud IS NULL OR is_fraud NOT IN (0, 1))
        AS invalid_rows
FROM bank_transactions

UNION ALL

SELECT
    'is_weekend',
    COUNT(DISTINCT is_weekend),
    SUM(is_weekend IS NULL OR is_weekend NOT IN (0, 1))
FROM bank_transactions

UNION ALL

SELECT
    'is_night_transaction',
    COUNT(DISTINCT is_night_transaction),
    SUM(is_night_transaction IS NULL
        OR is_night_transaction NOT IN (0, 1))
FROM bank_transactions

UNION ALL

SELECT
    'is_international',
    COUNT(DISTINCT is_international),
    SUM(is_international IS NULL OR is_international NOT IN (0, 1))
FROM bank_transactions

UNION ALL

SELECT
    'pin_changed_recently',
    COUNT(DISTINCT pin_changed_recently),
    SUM(pin_changed_recently IS NULL
        OR pin_changed_recently NOT IN (0, 1))
FROM bank_transactions;


-- 5. Check transaction time consistency
SELECT
    COUNT(*) AS total_rows,
    SUM(transaction_time IS NULL) AS missing_times,
    SUM(hour_of_day IS NULL) AS missing_hour_values,
    SUM(hour_of_day NOT BETWEEN 0 AND 23)
        AS invalid_hour_values,
    SUM(HOUR(transaction_time) <> hour_of_day)
        AS hour_mismatches
FROM bank_transactions;


-- 6. Check consistency between fraud labels and fraud types
SELECT
    is_fraud,
    fraud_type,
    COUNT(*) AS transaction_count
FROM bank_transactions
GROUP BY is_fraud, fraud_type
ORDER BY is_fraud, transaction_count DESC;


-- 7. Check negative distances, elapsed times and balances
SELECT
    SUM(distance_from_home_km IS NULL) AS missing_distances,
    SUM(distance_from_home_km < 0) AS negative_distances,
    SUM(time_since_last_txn_hrs IS NULL) AS missing_elapsed_times,
    SUM(time_since_last_txn_hrs < 0) AS negative_elapsed_times,
    SUM(account_balance IS NULL) AS missing_balances,
    SUM(account_balance < 0) AS negative_balances,
    SUM(account_age_years IS NULL) AS missing_account_ages,
    SUM(account_age_years < 0) AS negative_account_ages
FROM bank_transactions;


-- 8. Check leading/trailing spaces in selected categories
SELECT
    'country' AS column_name,
    SUM(country <> TRIM(country)) AS rows_with_outer_spaces,
    COUNT(DISTINCT country) AS distinct_categories
FROM bank_transactions

UNION ALL

SELECT
    'merchant_category',
    SUM(merchant_category <> TRIM(merchant_category)),
    COUNT(DISTINCT merchant_category)
FROM bank_transactions

UNION ALL

SELECT
    'payment_method',
    SUM(payment_method <> TRIM(payment_method)),
    COUNT(DISTINCT payment_method)
FROM bank_transactions

UNION ALL

SELECT
    'device_type',
    SUM(device_type <> TRIM(device_type)),
    COUNT(DISTINCT device_type)
FROM bank_transactions

UNION ALL

SELECT
    'fraud_type',
    SUM(fraud_type <> TRIM(fraud_type)),
    COUNT(DISTINCT fraud_type)
FROM bank_transactions;
