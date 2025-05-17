
SELECT 
    s.id AS plan_id, 
    s.owner_id,       
    'Savings' AS type,  
    MAX(s.transaction_date) AS last_transaction_date,  
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days  -- Days since last transaction

FROM savings_savingsaccount s

-- Only consider transactions that had confirmed inflow amounts
WHERE s.confirmed_amount > 0

-- Group by individual savings account and owner
GROUP BY s.id, s.owner_id

-- Keep only those accounts that have been inactive for over a year
HAVING DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365


UNION  -- Combine results with investment account findings



SELECT 
    p.id AS plan_id,  -- Unique investment plan ID
    p.owner_id,       -- User who owns the plan
    'Investment' AS type,  -- Tag the account as 'Investment'

    -- NOTE: Adjust this field if you have a proper transaction date for investments
    MAX(p.created_on) AS last_transaction_date,  
    DATEDIFF(CURDATE(), MAX(p.created_on)) AS inactivity_days  -- Days since last activity

FROM plans_plan p

-- Focus only on plans that are marked as investment funds
WHERE p.is_a_fund = 1

-- Group by individual investment plan and owner
GROUP BY p.id, p.owner_id

-- Keep only those investment plans inactive for more than 365 days
HAVING DATEDIFF(CURDATE(), MAX(p.created_on)) > 365;

