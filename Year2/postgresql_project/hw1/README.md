# Homework 1

> Deadline: 11th March 2024, 23:59:59

In this assignment, you will engage with a PostgreSQL database alongside the [`pgbench`](https://www.postgresql.org/docs/current/pgbench.html) tool.
Your tasks involve configuring the environment, populating the database, and examining the schema.
You will craft SQL queries to examine the data within the database and implement transactions to execute atomic operations.
Lastly, you will gain insight into assessing the database's performance.

For **submission instructions** and **useful Docker commands**, refer to the end of this document.

## Task 1 – Setting Up the Environment and Populating the Database

In this task, you will create a PostgreSQL database and populate it with data.
See the [README](../README.md) for instructions on setting up the PostgreSQL instance.

The database does not currently contain any data, it is freshly created, so you will need to populate it.
We have prepared a dump file for each student that contains the data you will use in the following assignments and homework.
Download your file named `<YOUR_UCO>.sql` from the link at [https://disa.fi.muni.cz/projects/PA036/](https://disa.fi.muni.cz/projects/PA036/) and place it in the `../data` folder. *The download link is accessible from MUNI network (use [VPN](https://www.fi.muni.cz/tech/unix/vpn.html.en) if needed).*

Your task is to populate the running instance with the data from the dump file.
The [documentation for the `pgdump` tool](https://www.postgresql.org/docs/current/app-pgdump.html) can be a useful resource for this task.

## Task 2 – Schema Understanding

In this assignment you will become familiar with the schema of the database. The pgbench schema consists of tables containing accounts, branches, history, and tellers. Understand the structure of these tables and their relationships.

Use the `psql` command line tool to do the following:
1. List all databases. 
2. List all tables with the prefix `pgbench_` and their size.
3. List the columns in the `pgbench_accounts` table.
4. List the size and type of the `pgbench_accounts_pkey` index.

If you are not familiar with the `psql` tool, you can consult its [documentation](https://www.postgresql.org/docs/current/app-psql.html) or use the `\?` command to list all available commands.

Additionally, observe the following relationships between the tables:
1. Any change of the account's abalance leads to a new record in history. 
2. Branch's bbalance contains the overall balance of all accounts in the branch.
3. Teller's tbalance contains the overall balance of withdrawals and deposits processed by the teller.

## Task 3 – Data Analysis

You already have the database populated with data and you understand the schema.
Now you will write SQL queries to analyze the data by solving the following tasks:

1. Find the top 10 accounts with the highest balances. Return only their IDs. Order the results by the balance in descending order. Place the SQL query into `task3-1.sql`. After writing the query, run `./generate task3-1` to populate the result file `task3-1.txt`.

2. Create a query to calculate the average balance per branch. Use `ROUND` to round the result to the nearest integer. Sort the results by the branch ID in ascending order. Place the SQL query into `task3-2.sql`. After writing the query, run `./generate task3-2` to populate the result file `task3-2.txt`. Result should have the following structure:

```text
 bid | average_balance
```

3. Perform a statistical analysis on the account balances distribution. Include mean, standard deviation, and percentiles 0, 0.5, 0.75, 0.9, 0.99, and 1. Round the results to two decimal places. You may find `CAST` function useful. Place the SQL query into `task3-3.sql`. After writing the query, run `./generate task3-3` to populate the result file `task3-3.txt`. The result should have the following structure:

```text
  mean_balance | std_dev | percentile_balance_0 | percentile_balance_50 | percentile_balance_75 | percentile_balance_90 | percentile_balance_99 | percentile_balance_100
```

4. Write a query to find the top 2 branches with the highest average balance per account. Include the number of accounts, total balance, and the number of transactions for each branch. Calculate the `(total balance)/(number of transaction)` ratio for each branch. If a branch has no transactions, the ratio should be `NULL`. Exclude branches with fewer than 100 accounts. Order the results by the average balance per account in descending order. Round the average balance per account to two decimal places. Place the SQL query into `task3-4.sql`. After writing the query, run `./generate task3-4` to populate the result file `task3-4.txt`. The result should have the following structure:

```text
 branch_id | num_accounts | total_balance | avg_balance_per_account | num_transactions | balance_transaction_ratio
```

## Task 4 – Transactions

Write a transaction that will perform the following operations:

1. Withdraw 500 from the account with ID 1. The withdrawal is being made by the teller with ID 3. Keep the transaction atomic. Do not forget to update the relevant tables. Place the SQL query into `task4-1.sql`.

2. Transfer 500 between two accounts (IDs 1 and 2), ensuring data integrity and consistency. Raise message "Transaction Successful" if the transaction is successful, and "Transaction Failed" if the sender has insufficient funds. Place the SQL query into `task4-2.sql`. You do not need to consider updating other tables.

## Task 5 – Measuring Performance

In this task, you will write a simple script to measure the performance of the PostgreSQL database using the `pgbench` tool.
It is a simple program for running benchmark tests on PostgreSQL.
It runs a given batch (a sequence of SQL commands) repeatedly and then calculates the average transaction rate as TPS (transactions per second).

You have been provided with three files: `select.sql`, `insert.sql`, and `update.sql`.
The files contain the SQL commands you want to measure the performance of.
You will create scripts that will run the `pgbench` tool with the desired configuration and measure the performance of the database for each of the provided files.

Use the following configuration in your scripts:

- single client
- single thread
- scale factor set to 3
- duration of 2 minutes
- set seed to your UCO
- do not perform any vacuuming

Consult the [documentation of the `pgbench` tool](https://www.postgresql.org/docs/current/pgbench.html) on what parameters you need to use to achieve the required configuration.

Place the appropriate docker command in the following files:
- Place the docker command (`docker run ...`) you used to measure the performance of `select.sql` into the file called `task5-1.sh`.
- Place the docker command (`docker run ...`) you used to measure the performance of `insert.sql` into the file called `task5-2.sh`.
- Place the docker command (`docker run ...`) you used to measure the performance of `update.sql` into the file called `task5-3.sh`.

See `../setup.sh` for an example of how to run the `psql` tool in a Docker container. The `pgbench` tool can be used in a similar way.

Check that running `bash task5-{1,2,3}.sh` will execute the `pgbench` tool with the desired configuration.

## Useful Docker Commands

The default PostgreSQL instance runs in a Docker container named `pa036`.

Commands to manage Docker containers:
- `docker ps` – list running containers
  - `docker ps -a` – list all running and stopped containers
- `docker exec -it <container_name> sh` – open shell inside the running container
- `docker logs <container_name>` – fetch logs from the container
- `docker stop <container_name>` – stop the container
- `docker remove <container_name>` – remove the stopped container

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
