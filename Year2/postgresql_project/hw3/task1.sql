CREATE TABLE accounts_partitioned (
    aid INTEGER NOT NULL,
    bid INTEGER,
    abalance INTEGER,
    type character varying(255),
    iban character(24),
    owner character varying(50),
    email character varying(50),
    phone character(16),
    created character(24),
    account_number character varying(30)
) partition by range (aid);


CREATE TABLE accounts_partition_1 PARTITION OF accounts_partitioned FOR VALUES FROM (MINVALUE) TO (100000);
CREATE TABLE accounts_partition_2 PARTITION OF accounts_partitioned FOR VALUES FROM (100000) TO (200000);
CREATE TABLE accounts_partition_3 PARTITION OF accounts_partitioned FOR VALUES FROM (200000) TO (MAXVALUE);

INSERT INTO accounts_partitioned SELECT * FROM pgbench_accounts;
