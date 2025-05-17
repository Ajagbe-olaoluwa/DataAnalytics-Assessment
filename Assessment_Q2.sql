-- STEP 1: Summarize transactions per customer
WITH txn_summary AS (
    SELECT
        sa.owner_id,  -- Customer ID
        COUNT(*) AS total_txns,  -- Total number of transactions
        TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) + 1 AS active_months  
        -- Duration between the first and last transaction in months (+1 to avoid division by zero)
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),

-- STEP 2: Calculate the average number of transactions per month for each customer
customer_avg_txn AS (
    SELECT
        ts.owner_id,
        ROUND(ts.total_txns / ts.active_months, 2) AS avg_txn_per_month  -- Avg transactions per month
    FROM txn_summary ts
    WHERE ts.active_months > 0  -- Exclude any customers with no active months
),

-- STEP 3: Categorize customers based on their average transaction frequency
categorized AS (
    SELECT
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,  -- Assign frequency category
        avg_txn_per_month
    FROM customer_avg_txn
)

-- STEP 4: Aggregate counts and averages for each frequency category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,  -- Number of customers in each category
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month  -- Avg transaction rate per category
FROM categorized
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Custom sort order

