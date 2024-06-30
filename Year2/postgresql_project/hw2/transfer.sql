\set aid_source random(1, 100000 * :scale)
\set aid_destination random(1, 100000 * :scale)
\set bid_source random(1, 1 * :scale)
\set bid_destination random(1, 1 * :scale)
\set tid_source random(1, 10 * :scale)
\set tid_destination random(1, 10 * :scale)
\set delta random(0, 5000)

BEGIN;

-- Source:
UPDATE pgbench_accounts SET abalance = abalance - :delta WHERE aid = :aid_source;
UPDATE pgbench_tellers SET tbalance = tbalance - :delta WHERE tid = :tid_source;
UPDATE pgbench_branches SET bbalance = bbalance - :delta WHERE bid = :bid_source;
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid_source, :bid_source, :aid_source, -:delta, CURRENT_TIMESTAMP);

-- Destination:
UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid_destination;
UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid_destination;
UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid_destination;
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid_destination, :bid_destination, :aid_destination, :delta, CURRENT_TIMESTAMP);

END;
