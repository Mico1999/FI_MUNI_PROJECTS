# Homework 3 – Data Partitioning, Backup and Restore, and Triggers

> Deadline: 8th April 2024, 23:59:59
> Planned evaluation dates: Friday, March 29, 9:00am; Friday April 5, 9:00am. There can be some other unscheduled checkes.

## Task 1 – Data Partitioning

Consider a scenario where the `pgbench` database is growing rapidly and the `pgbench_accounts` table is becoming too large to manage efficiently.
In this task, you will implement table partitioning based on account ID to distribute data across multiple partitions to improve query performance and table manageability.

Consider the following query:
```sql
SELECT SUM(abalance) FROM pgbench_accounts WHERE aid BETWEEN 42000 AND 90000;
```

Your task is to implement table partitioning on the `pgbench_accounts` table and measure the performance improvement of the above query.
Divide the `pgbench_accounts` table into `n` partitions so that:
1. each partition contains approximately the same number of rows – uniform partitioning,
2. the overall cost of the query on the partitioned table should be at least 2x lower than the cost of the same query on the original table,
3. the number of partitions `n` should be as small as possible, and
4. the partitioned table should be named `accounts_partitioned`.

Place:
- the SQL queries that you used to create the partitioned table, the partitions, and populate the table from `pgbench_accounts` into the file called `task1.sql`
- the result of EXPLAIN ANALYZE for the query on the original table into the file called `explain-pgbench-accounts.txt`
- the result of EXPLAIN ANALYZE for the query on the partitioned table into the file called `explain-accounts-partitioned.txt`
- the cost of the query on the original table into the file called `cost-pgbench-accounts.txt`
- the cost of the query on the partitioned table into the file called `cost-accounts-partitioned.txt`

## Task 2 – Backup and Restore

Sometimes, it is necessary to back up and restore a database to ensure data integrity and to recover from failure.
In this task, you will explore the backup and restore process in PostgreSQL.

### Subtask 2.1 – Backup

Export the data from the `pgbench_history` table into a file called `backup.sql` and commit it to the repository.
Subsequently, drop the `pgbench_history` table and verify that it has been dropped successfully.

### Subtask 2.2 – Restore

Restore the `pgbench_history` table from the `backup.sql` file.
Verify that the data has been restored successfully.

## Task 3 – Business Logic Implementation

The objective of this task is to reinforce the understanding of how business logic can be implemented in PostgreSQL.
Ensure that your solutions are efficient and handle edge cases gracefully.

### Subtask 3.1 – Non-negative Balance

Implement a business constraint that prevents inserting or updating a row in the accounts table where the balance column is less than zero.
If the constraint is violated, the operation must **raise an exception**.
Place the SQL query into `task3-1.sql`. Notice: If there are records violating the constraint (so it cannot be applied), update the violating records to zero balance.

### Subtask 3.2 – Derived Data

Implement a trigger that automatically updates the bbalance column in the branches table whenever the account balance is updated or a new account created or removed.
Place the SQL query into `task3-2.sql`.

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
