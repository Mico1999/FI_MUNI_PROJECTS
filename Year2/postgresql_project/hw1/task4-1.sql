BEGIN;
UPDATE pgbench_accounts SET abalance = abalance - 500 WHERE aid = 1;
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (3, (SELECT bid from pgbench_accounts WHERE aid = 1), 1, -500, CURRENT_TIMESTAMP);
UPDATE pgbench_tellers SET tbalance = tbalance - 500 WHERE tid = 3 AND bid = (SELECT bid from pgbench_accounts WHERE aid = 1);
UPDATE pgbench_branches SET bbalance = bbalance - 500 WHERE bid = (SELECT bid from pgbench_accounts WHERE aid = 1);
COMMIT;