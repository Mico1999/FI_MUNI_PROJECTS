# Homework 4 – Investigating Transactions in PostgreSQL

> Deadline: 22th April 2024, 23:59:59
> Planned evaluation dates: Friday, 12th April, 9:00am; Friday, 19th April, 9:00am. There can be some other unscheduled checkes.
> After deadline: 1st correction attempt deadline: Thu, 25th April, 9:00am;
>                 2nd correction attempt deadline: Mon, 29th April, 9:00am.

## Installation

```shell
# Create a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install the dependencies
pip install -r requirements.txt
```

- Note that the homework will be evaluated using Python 3.10.

## Task 1 – Correcting a Transaction

A student named Hubert wrote a Python script (`student.py`) that uses a PostgreSQL database to transfer money between two accounts (his and his friend's).
His friend owes him 1000 CZK, so he transferred the money from his friend's account to his account.
He has also recently changed his phone number and email address and wants to update them as well.
He noticed that the whole transaction takes a long time and asked you to help him.

Your task is to fix the application so that the money is transferred correctly, the phone number and email are updated, records about the transaction are propagated to the history table and the "transaction" is committed.
You do not need to worry about updating the teller and branch tables.

Do the minimal changes to the code to make it work correctly.
Keep the two connections/transaction/cursor approach as is.
Fix `student.py` and commit your changes.

## Task 2 – Investigating Parallel Transactions

In this task, you will investigate the behavior of a set of transactions in PostgreSQL.
There is a bash script `run.sh` that runs the `client.py` script in parallel, simulating multiple users transferring money between accounts.
Your task is to run the script and observe its behavior.
You should observe that the script finished with errors, and the money was not transferred correctly.

Use the following command to run the script:
```shell
./run.sh > out.log 2> err.log
```
It will run the script and redirect the output to different files so that you can see the output and errors separately.

### Subtask 2.1 – Resolving the Deadlock

Your first task is to resolve the deadlock in the `client.py` script so that the script `run.sh` finishes successfully without any errors.
Fix the `client.py` script and commit your changes.

### Subtask 2.2 – Correctness

1. Is the code for transferring money between accounts correct?
If not, fix the `client.py` script so that the money is transferred correctly.
The balance of the accounts should be the same before and after the transactions.

2. Second, you should not focus only on the successful completion of the transaction.
Is there a bug in the script that could lead to incorrect results if an SQL command fails?

Fix the `client.py` script and commit your changes.

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
