import argparse
import sys
import csv

import psycopg


def create_account_statement(aid: int, start: str, end: str):
    """
    Retrieve the account statement for the given account and date range.

    :param aid: Account ID
    :param start: Start date in the format "YYYY-MM-DD", e.g., "2024-02-19"
    :param end: End date in the format "YYYY-MM-DD", e.g., "2024-02-24"
    """

    with psycopg.connect("dbname=pa036_db host=pa036 user=user port=5432") as conn:
        conn.autocommit = False

        with conn.cursor() as cursor:
            try:

                cursor.execute(
                    """
                    CREATE INDEX IF NOT EXISTS his_aid ON pgbench_history USING HASH (aid)
                    """
                )

                cursor.execute(
                    """
                    CREATE INDEX IF NOT EXISTS his_mtime ON pgbench_history (mtime)
                    """
                )
              
                cursor.execute(
                    """
                    SELECT COALESCE(SUM(ph.delta), 0) AS initial_balance
                        FROM pgbench_accounts pa
                        LEFT JOIN pgbench_history ph ON pa.aid = ph.aid
                        WHERE ph.mtime < %s AND pa.aid = %s 
                    """,
                    (start, aid),
                )
                initial_balance = str(cursor.fetchone()[0])

                cursor.execute(
                    """
                    SELECT COALESCE(SUM(ph.delta), 0) AS initial_balance
                        FROM pgbench_accounts pa
                        LEFT JOIN pgbench_history ph ON pa.aid = ph.aid
                        WHERE ph.mtime < %s AND pa.aid = %s 
                    """,
                    (end, aid),
                )
                final_balance = str(cursor.fetchone()[0])

                cursor.execute(
                    """
                    WITH history_stats AS (
                        SELECT
                            ph.mtime AS mtime,
                            (SELECT th.aid FROM pgbench_history th WHERE th.aid <> ph.aid AND th.mtime = ph.mtime) AS aid_other, 
                            ph.delta AS delta
                        FROM pgbench_history ph
                        LEFT JOIN pgbench_accounts pa ON ph.aid = pa.aid
                        WHERE ph.aid = %s AND ph.mtime > %s AND ph.mtime < %s
                    )
                    SELECT 
                        CAST(hs.mtime AS text),
                        CASE
                            WHEN hs.aid_other IS NULL AND hs.delta < 0 THEN %s
                            WHEN hs.aid_other IS NULL AND hs.delta > 0 THEN %s
                            ELSE %s
                        END AS ttype,
                        hs.aid_other,
                        delta,
                        NULL AS curr_balance
                    FROM history_stats hs
                    
                    UNION

                    SELECT CONCAT(CAST(%s AS text), CAST(%s AS text)) AS mtime, %s AS ttype, NULL AS aid_other, NULL AS delta, %s AS curr_balance

                    UNION 

                    SELECT CONCAT(CAST(%s AS text), CAST(%s AS text)) AS mtime, %s AS ttype, NULL AS aid_other, NULL AS delta, %s AS curr_balance

                    ORDER BY mtime ASC;
                    """,
                    (aid, start, end, 'withdrawal', 'deposit', 'transfer', start, ' 00:00:00', 'initial', initial_balance, end, ' 00:00:00', 'final', final_balance),
                )

                result = cursor.fetchall()

                with open('statement.csv', 'w', newline='') as statement_file:
                    writer = csv.writer(statement_file)
                    header = ["mtime", "ttype", "aid_other", "delta", "curr_balance"]
                    
                    writer.writerow(header)

                    for x in result:
                        writer.writerow([x[0], x[1], x[2] if x[2] != None else '', x[3] if x[3] != None else '', x[4] if x[4] != None else ''])

                conn.commit()

            except (Exception, psycopg.DatabaseError) as error:
                print(f"Error: {error}", file=sys.stderr, flush=True)
                print("Reverting transaction", file=sys.stderr, flush=True)

                conn.rollback()
                exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--account-id",
        type=int,
        required=True,
        help="Account ID",
    )
    parser.add_argument(
        "--start",
        type=str,
        required=True,
        help="Start date in the format 'YYYY-MM-DD', e.g., '2024-02-19'",
    )
    parser.add_argument(
        "--end",
        type=str,
        required=True,
        help="End date in the format 'YYYY-MM-DD', e.g., '2024-02-24'",
    )
    args = parser.parse_args()

    account_id = args.account_id
    start_date = args.start
    end_date = args.end

    create_account_statement(account_id, start_date, end_date)
