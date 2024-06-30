SELECT ROUND(avg(abalance), 2) AS mean_balance, ROUND(stddev(abalance),2) AS std_dev,
ROUND((CAST(percentile_cont(0) WITHIN GROUP (ORDER BY abalance) AS numeric)), 2) as percentile_balance_0,
ROUND((CAST(percentile_cont(0.5) WITHIN GROUP (ORDER BY abalance) AS numeric)), 2) as percentile_balance_50,
ROUND((CAST(percentile_cont(0.75) WITHIN GROUP (ORDER BY abalance) AS numeric)), 2) as percentile_balance_75,
ROUND((CAST(percentile_cont(0.90) WITHIN GROUP (ORDER BY abalance) AS numeric)), 2) as percentile_balance_90,
ROUND((CAST(percentile_cont(0.99) WITHIN GROUP (ORDER BY abalance) AS numeric)), 2) as percentile_balance_99,
ROUND((CAST(percentile_cont(1) WITHIN GROUP (ORDER BY abalance) AS numeric)), 2)  as percentile_balance_100 FROM pgbench_accounts;
