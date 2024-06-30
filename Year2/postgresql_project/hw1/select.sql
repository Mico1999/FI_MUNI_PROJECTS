\set aid random(1, 100000 * :scale)
\set bid random(1, 1 * :scale)
\set tid random(1, 10 * :scale)
\set delta random(-5000, 5000)

BEGIN;

-- Select balance of an account:
SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
-- Find the total balance for all accounts in a specific branch:
SELECT bid, SUM(abalance) AS total_balance FROM pgbench_accounts WHERE bid = :bid GROUP BY bid;
-- List the top 10 accounts with the highest balance:
SELECT aid, abalance FROM pgbench_accounts ORDER BY abalance DESC LIMIT 10;
-- Retrieve the average balance for each branch:
SELECT bid, AVG(abalance) AS average_balance FROM pgbench_accounts GROUP BY bid;
-- Find the total number of transactions for a specific teller:
SELECT tid, COUNT(*) AS transaction_count FROM pgbench_history WHERE tid = :tid GROUP BY tid;
-- Get the details of the latest 5 transactions:
SELECT * FROM pgbench_history ORDER BY mtime DESC LIMIT 5;
-- Retrieve the total number of branches:
SELECT COUNT(*) AS total_branches FROM pgbench_branches;
-- Find the branch with the highest total balance across all accounts:
SELECT bid, SUM(abalance) AS total_balance FROM pgbench_accounts GROUP BY bid ORDER BY total_balance DESC LIMIT 1;
-- List all tellers and the average transaction amount they handle:
SELECT tid, AVG(delta) AS avg_transaction_amount FROM pgbench_history GROUP BY tid;
-- Retrieve the accounts with a balance greater than 1000 in a specific branch:
SELECT * FROM pgbench_accounts WHERE bid = :bid AND abalance > 1000;
-- Find all transactions with a delta between -1000 and 1000:
SELECT * FROM pgbench_history WHERE -1000 < delta AND delta < 1000;

END;
