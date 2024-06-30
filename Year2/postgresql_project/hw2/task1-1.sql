CREATE INDEX task1_1_mtime_index ON pgbench_history (mtime DESC NULLS FIRST);

CREATE INDEX task1_1_delta_index ON pgbench_history (delta);

CREATE INDEX task1_1_tid_index ON pgbench_history USING HASH (tid);