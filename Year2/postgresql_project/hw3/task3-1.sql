UPDATE pgbench_accounts SET abalance = 0 WHERE abalance < 0;

ALTER TABLE pgbench_accounts ADD CONSTRAINT non_negative_balance
    CHECK (abalance >= 0);
