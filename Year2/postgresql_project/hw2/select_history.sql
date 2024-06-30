\set aid random(1, 100000 * :scale)
\set bid random(1, 1 * :scale)
\set tid random(1, 10 * :scale)
\set delta random(-5000, 5000)

BEGIN;

-- Find the total number of transactions for a specific teller:
SELECT tid, COUNT(*) AS transaction_count FROM pgbench_history WHERE tid = :tid GROUP BY tid;
-- Get the details of the latest 5 transactions:
SELECT * FROM pgbench_history ORDER BY mtime DESC LIMIT 5;
-- Find all transactions with a delta between -1000 and 1000:
SELECT * FROM pgbench_history WHERE -1000 < delta AND delta < 1000;

END;
