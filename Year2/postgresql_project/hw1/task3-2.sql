SELECT bid, ROUND(AVG(abalance)) AS average_balance FROM pgbench_accounts
GROUP BY bid
ORDER BY bid ASC;