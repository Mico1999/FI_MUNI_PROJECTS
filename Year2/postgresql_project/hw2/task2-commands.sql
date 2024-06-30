CREATE INDEX task2_idx ON pgbench_accounts (type, reverse(email) text_pattern_ops);
