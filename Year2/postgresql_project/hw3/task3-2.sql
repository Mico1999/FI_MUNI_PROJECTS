CREATE OR REPLACE FUNCTION update_branch_balance() RETURNS TRIGGER AS 
$$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            UPDATE pgbench_branches
            SET bbalance = (
                SELECT SUM(abalance) FROM pgbench_accounts WHERE bid = OLD.bid
            )
            WHERE bid = OLD.bid;
        END IF;

        IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
            UPDATE pgbench_branches
            SET bbalance = (
                SELECT SUM(abalance) FROM pgbench_accounts WHERE bid = NEW.bid
            )
            WHERE bid = NEW.bid;
        
        END IF;

        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_branch_table_trigger
AFTER INSERT OR UPDATE OR DELETE ON pgbench_accounts
FOR EACH ROW
EXECUTE FUNCTION update_branch_balance();
