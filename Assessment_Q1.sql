-- STEP 1: Aggregate savings information per user
WITH savings AS (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,                 
        SUM(confirmed_amount) AS total_savings       
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0                     
    GROUP BY owner_id
),

-- STEP 2: Aggregate investment information per user
investments AS (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count                 -- Total number of investment plans
    FROM plans_plan
    WHERE is_a_fund = 1                              -- Only consider actual investment funds
    GROUP BY owner_id
)

-- STEP 3: Join users with their savings and investment summaries
SELECT 
    uc.id AS owner_id,                                
    CONCAT(uc.first_name, ' ', uc.last_name) AS name, 
    s.savings_count,                                  
    i.investment_count,                              
    ROUND(s.total_savings / 100.0, 2) AS total_deposits -- Convert kobo to Naira and round to 2 decimals
FROM users_customuser uc
JOIN savings s ON s.owner_id = uc.id                 -- Only include users with savings
JOIN investments i ON i.owner_id = uc.id             -- Only include users with investments
ORDER BY total_deposits DESC;                        -- Rank users by total deposits (highest first)

