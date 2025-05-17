

# DataAnalytics SQL Assessment

## What I Did for Each Question

### 1. Account Inactivity Alert

I looked for savings and investment accounts that haven’t had any inflow transactions in the last year. For savings, I checked the latest transaction date; for investments, I used the created date (since transaction dates weren’t clear). Then I combined the two results into one list of inactive accounts.
**Had to be careful** picking the right date fields and making sure the UNION matched up.

### 2. Customer Lifetime Value (CLV)

Calculated how long each customer has been with us in months. Counted their total transactions and used the formula they gave to estimate CLV based on average profit per transaction. Used `NULLIF` to avoid dividing by zero if tenure was zero.
This was pretty straightforward once I handled that edge case.

### 3. Transaction Frequency Analysis

Counted how many transactions each customer did, figured out how many months they were active (added 1 so we don’t get zero months), then found their average monthly transactions. Finally, put them into categories: High, Medium, or Low frequency based on the average.
Using CTEs made it easier to organize the steps.

### 4. Savings vs Investments Summary

Joined users with their total number of savings and investment accounts, plus summed up their confirmed savings amounts. Sorted the list by total deposits so the biggest savers show up first.
Had to make sure the joins worked correctly since sometimes the IDs could be tricky.

---

## Challenges / What I Learned

* Working with different date fields across tables was a bit confusing, but careful selection fixed it.
* Calculating months between dates needs some tweaks to handle cases where customers just joined.
* Using CTEs made the queries easier to read and debug.

