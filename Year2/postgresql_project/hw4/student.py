import psycopg

# I do not know why, but this takes a while to finish: ¯\_(ツ)_/¯
try:
    # Lets open two connections to the database, and start a transaction on each of them.
    # I read somewhere that this should make the transactions execute faster.
    conn1 = psycopg.connect("dbname=pa036_db host=pa036 user=user port=5432")
    conn2 = psycopg.connect("dbname=pa036_db host=pa036 user=user port=5432")

    # I know when to commit, so I will do it manually!
    conn1.autocommit = False
    conn2.autocommit = False

    c1 = conn1.cursor()
    c2 = conn2.cursor()

    money = 1_000

############################## Friend's account ####################################################

    c2.execute(
        f"UPDATE pgbench_accounts SET abalance = abalance - {money} WHERE aid = 1;"
    )

    c2.execute(
        (
            f"INSERT INTO pgbench_history (tid, bid, aid, delta, mtime)"
            f"VALUES (1, 1, 1, -{money}, CURRENT_TIMESTAMP);"
        )
    )

    c2.execute("SELECT abalance FROM pgbench_accounts WHERE aid = 1")

    print(f"New account 1 balance: {c2.fetchone()[0]}")

    # Here we go!
    conn2.commit()

############################## Hubert's account ####################################################
    
    c1.execute(
        f"UPDATE pgbench_accounts SET abalance = abalance + {money} WHERE aid = 2;"
    )

    c1.execute(
        (
            f"INSERT INTO pgbench_history (tid, bid, aid, delta, mtime)"
            f"VALUES (1, 1, 2, {money}, CURRENT_TIMESTAMP);"
        )
    )

    c1.execute("UPDATE pgbench_accounts SET phone = '+420 777 888 999' WHERE aid = 2;")

    c1.execute("UPDATE pgbench_accounts SET email = 'hubert@polivka.cz' WHERE aid = 2;")

    c1.execute("SELECT abalance FROM pgbench_accounts WHERE aid = 2")

    print(f"New account 2 balance: {c1.fetchone()[0]}")

    # Here we go!
    conn1.commit()

    # If we got here, everything went well!
    # I will print a message to let the user know that the transaction was successful.
    # The problem is that this is not printed...
    print("Transaction completed successfully")

except (Exception, psycopg.DatabaseError) as error:
    print(f"Error: {error}")
    print("Reverting transaction")

    conn1.rollback()
    conn2.rollback()
