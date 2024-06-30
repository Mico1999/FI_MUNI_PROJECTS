WITH branch_stats AS (
    SELECT
        pa.bid AS branch_id,
        COUNT(pa.aid) AS num_accounts,
        (SELECT b.bbalance FROM pgbench_branches b WHERE b.bid = pa.bid) AS total_balance,
        ROUND(AVG(pa.abalance), 2) AS avg_balance_per_account,
        (SELECT COUNT(*) FROM pgbench_history ph WHERE ph.bid = pa.bid) AS num_transactions
    FROM pgbench_accounts pa
    GROUP BY
        pa.bid
    HAVING
        COUNT(pa.aid) >= 100
)
SELECT 
    bs.branch_id,
    bs.num_accounts,
    bs.total_balance,
    bs.avg_balance_per_account,
    bs.num_transactions,
    CASE
        WHEN bs.num_transactions > 0 THEN bs.total_balance / bs.num_transactions
        ELSE NULL
    END AS balance_transaction_ratio
FROM
    branch_stats bs
ORDER BY
    avg_balance_per_account DESC
LIMIT 2;