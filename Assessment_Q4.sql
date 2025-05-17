
SELECT
    uc.id AS customer_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,

    -- Calculate how many months the customer has been active
    TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()) AS tenure_months,

    -- Count total number of confirmed transactions per customer
    COUNT(s.id) AS total_transactions,

    -- Estimate CLV using simplified model:
    -- CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()), 0)) * 12 *
        (SUM(s.confirmed_amount) * 0.001 / COUNT(s.id)),
        2
    ) AS estimated_clv

FROM users_customuser uc

-- Join confirmed savings transactions
JOIN savings_savingsaccount s 
    ON s.owner_id = uc.id
WHERE s.confirmed_amount > 0

-- Group by customer to calculate aggregates per person
GROUP BY uc.id, uc.first_name, uc.last_name, tenure_months

-- Rank customers by their estimated CLV from highest to lowest
ORDER BY estimated_clv DESC;

