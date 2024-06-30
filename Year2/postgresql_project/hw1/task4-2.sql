BEGIN;

do $$

BEGIN

IF (SELECT abalance FROM pgbench_accounts WHERE aid = 1) >= 500 THEN

    UPDATE pgbench_accounts SET abalance = abalance - 500 WHERE aid = 1;
    UPDATE pgbench_accounts SET abalance = abalance + 500 WHERE aid = 2;
    RAISE NOTICE 'Transaction Successful';

ELSE
    RAISE NOTICE 'Transaction Failed';
END IF;

END $$;

COMMIT;