import argparse
import sys

import psycopg


def transfer_money(amount, account_A_aid, account_B_aid):
    """Transfer money from account A to account B."""

    with psycopg.connect("dbname=pa036_db host=pa036 user=user port=5432") as conn:
        conn.autocommit = False

        with conn.cursor() as cursor:
            try:
                if account_A_aid < account_B_aid:
                    cursor.execute(
                        "SELECT abalance FROM pgbench_accounts WHERE aid = %s FOR UPDATE",
                        (account_A_aid,),
                    )
                    balance_account_A = int(cursor.fetchone()[0])
                    balance_account_A -= amount

                    # ! DO NOT REMOVE THIS LINE, THIS SLEEP MUST BE PRESENT BEFORE THE FIRST UPDATE:
                    cursor.execute("SELECT pg_sleep(RANDOM() / 3);")

                    # Withdraw from account A
                    cursor.execute(
                        "UPDATE pgbench_accounts SET abalance = %s WHERE aid = %s",
                        (balance_account_A, account_A_aid),
                    )

                    cursor.execute(
                        "SELECT abalance FROM pgbench_accounts WHERE aid = %s FOR UPDATE",
                        (account_B_aid,),
                    )
                    balance_account_B = int(cursor.fetchone()[0])
                    balance_account_B += amount

                    # ! DO NOT REMOVE THIS LINE, THIS SLEEP MUST BE PRESENT BEFORE THE SECOND UPDATE:
                    cursor.execute("SELECT pg_sleep(RANDOM() / 3);")

                    # Deposit to account B
                    cursor.execute(
                        "UPDATE pgbench_accounts SET abalance = %s WHERE aid = %s",
                        (balance_account_B, account_B_aid),
                    )
                else:
                    cursor.execute(
                        "SELECT abalance FROM pgbench_accounts WHERE aid = %s FOR UPDATE",
                        (account_B_aid,),
                    )
                    balance_account_B = int(cursor.fetchone()[0])
                    balance_account_B += amount

                    # ! DO NOT REMOVE THIS LINE, THIS SLEEP MUST BE PRESENT BEFORE THE FIRST UPDATE:
                    cursor.execute("SELECT pg_sleep(RANDOM() / 3);")

                    # Deposit to account B
                    cursor.execute(
                        "UPDATE pgbench_accounts SET abalance = %s WHERE aid = %s",
                        (balance_account_B, account_B_aid),
                    )

                    cursor.execute(
                        "SELECT abalance FROM pgbench_accounts WHERE aid = %s FOR UPDATE",
                        (account_A_aid,),
                    )
                    balance_account_A = int(cursor.fetchone()[0])
                    balance_account_A -= amount

                    # ! DO NOT REMOVE THIS LINE, THIS SLEEP MUST BE PRESENT BEFORE THE SECOND UPDATE:
                    cursor.execute("SELECT pg_sleep(RANDOM() / 3);")

                    # Withdraw from account A
                    cursor.execute(
                        "UPDATE pgbench_accounts SET abalance = %s WHERE aid = %s",
                        (balance_account_A, account_A_aid),
                    )

                cursor.execute(
                    """
                    INSERT INTO pgbench_history (tid, bid, aid, delta, mtime)
                    VALUES (1, 1, %s, %s, CURRENT_TIMESTAMP)
                    """,
                    (account_A_aid, -amount),
                )
                cursor.execute(
                    """
                    INSERT INTO pgbench_history (tid, bid, aid, delta, mtime)
                    VALUES (1, 1, %s, %s, CURRENT_TIMESTAMP)
                    """,
                    (account_B_aid, amount),
                )

                conn.commit()

            except (Exception, psycopg.DatabaseError) as error:
                print(f"Error: {error}", file=sys.stderr, flush=True)
                print("Reverting transaction", file=sys.stderr, flush=True)

                conn.rollback()
                exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--amount",
        type=int,
        required=True,
        help="Amount of money to transfer from account A to account B",
    )
    parser.add_argument(
        "--from-account-id",
        type=int,
        required=True,
        help="Account ID from which to transfer the money",
    )
    parser.add_argument(
        "--to-account-id",
        type=int,
        required=True,
        help="Account ID to which to transfer the money",
    )
    args = parser.parse_args()

    for i in range(20):
        print(
            f"Transferring {args.amount}: {args.from_account_id} -> {args.to_account_id} #{i}",
            flush=True,
        )
        transfer_money(args.amount, args.from_account_id, args.to_account_id)
