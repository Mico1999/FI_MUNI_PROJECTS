# Homework 5 – Accelerating the Generation of Account Statements

> Deadline: May 6, 2024 with preevaluations on Fridays - April 26 and May 3 at 9 am.

> Corrections: for 1st, the due date is Thursday May 9, 2024 at 9 am; for 2nd, the due date is Monday May 13, 2024 at 9 am.

## Installation

```shell
# Create a virtual environment
python -m venv .venv
source .venv/bin/activate

# Install the dependencies
pip install -r requirements.txt
```

- Note that the homework will be evaluated using Python 3.10.

## Task 1

You have been asked to speed up a script for generating bank statements for an undisclosed bank.

> The bank's employees have been manually generating statements for their customers for years. As the number of customers has grown, the bank has realized that the current process is not scalable. With recent improvements in technology, the bank decided to automate the process. The bank hired an outside company to develop a script that would generate statements for its customers. The project was a success, and the bank was able to generate statements for all of its customers in a fraction of the time it took to generate them manually. However, the bank has found that the script is not as fast as it could be. In addition, several FitTech companies have sprung up and started competing with the bank. It seems that the bank's script is not as efficient as it could be because the FitTech companies are able to generate statements even faster. In order to prevent the script from falling into the wrong hands (or possibly seeing how inefficient it is), the bank has decided to keep the script private and not share it with anyone.

The bank has decided to outsource the development of a new faster script to you, a bright student at the Faculty of Informatics with a robust database background and a solid moral compass.
Your task is to develop a Python script that generates account statements for a given account number (aid) and a time interval (as two dates).
You will have to generate the account statements on your own, conforming to the following legacy format (this is just an example for better understanding; the actual format is the CSV format described below):

```
           mtime            |   ttype    | aid_other | delta | curr_balance
----------------------------+------------+-----------+-------+--------------
 2024-02-02 00:00:00        | initial    |           |       |         3205
 2024-02-02 14:17:50.278885 | deposit    |           |  4774 |
 2024-02-04 03:08:35.752801 | transfer   |     69258 |  4259 |
 2024-02-04 12:39:03.569941 | withdrawal |           |  -932 |
 2024-02-08 00:00:00        | final      |           |       |        11306
```

The statement consists of the following columns:
- `mtime` – the time of the transaction
- `ttype` – the type of the transaction – `deposit`/`withdrawal`/`transfer`/`initial`/`final`
  - `deposit` – a deposit to the account
  - `withdrawal` – a withdrawal from the account
  - `transfer` – a wire transfer to another account
  - `initial` – the initial balance of the account in the given time interval
  - `final` – the final balance of the account in the given time interval
- `aid_other` – the account ID of the other party involved in the transaction (e.g., the account ID of the recipient in the case of a wire transfer)
- `delta` – the amount of money involved in the transaction (positive for deposits, negative for withdrawals)
- `curr_balance` – the current balance of the account after the transaction

You are given a skeleton Python script `generate_statement_file.py`.
Your task is to implement the generation of bank statements for a given account number (aid) and a time interval (as two dates).
Note that the start date is _inclusive_ (transactions on that day are included), while the end date is _exclusive_ (transactions on that day are not included).
The script will save the generated statement to a file named `statement.csv' in this format:

```csv
mtime,ttype,aid_other,delta,curr_balance
2024-02-02 00:00:00,initial,,,3205
2024-02-02 14:17:50.278885,deposit,,4774,
2024-02-04 03:08:35.752801,transfer,69258,4259,
2024-02-04 12:39:03.569941,withdrawal,,-932,
2024-02-08 00:00:00,final,,,11306
```

Notes:
1. Assume that `mtime` uniquely identifies withdrawals, deposits and wire transfers, i.e. it is the transaction ID. In particular, a wire transfer is represented by two records in the `pgbench_history` table, one for the sender and one for the recipient. The `mtime` of the two records is the same.
2. You should also test your solution for cases where the start of the interval is before the first transaction and the end is well after the last transaction. The initial and final states of the account should be generated correctly in such cases.
3. Remember that the interval may not contain any transactions; this output type is not tested and is undefined.
4. Use only `psycopg` and the standard library. No other external libraries are allowed.
5. The statements should be generated in the order of the `mtime` column.
6. The time performance of your solution will have a positive effect on your position in the final course ranking for an award.

## Submission

Plagiarism will not be tolerated; make sure your submissions are original.
You can refer to the PostgreSQL documentation and additional learning resources for assistance.
Submit your assignment before the specified deadline.

[Instructions on how to submit your homework.](https://gitlab.fi.muni.cz/groups/pa036-students/-/wikis/02-Submitting-(and-Resubmitting)-Homework)

Keep in mind that only the explicitly mentioned files are considered for the evaluation of your homework.
Changes made to other files are ignored.

When submitting your files, make sure that you use in the docker command the right PostgreSQL instance:
- Host: `pa036`
- Port: `5432`
- User: `user`
- Database: `pa036_db`
