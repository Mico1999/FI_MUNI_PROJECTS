# Homework 2 – Indexing, Performance, and Optimization

> Deadline: 25th March 2024, 23:59:59

> Planned evaluation dates: Monday, March 18, 9:00am; Friday March 22, 9:00am. There can be some other unscheduled checkes.

Hint: Running `VACUUM ANALYZE <table_name>;` may help you to update query plan.

## Task 1 – Indexing and Performance

Now that you have measured the performance of the database with the `pgbench` tool and have a good understanding of the schema and the queries you can run against the database, you will try to optimize the performance of the selected queries.
Your task is to reduce the time it takes to execute the files `select_history.sql` and `transfer.sql` in two subtasks by creating indexes.
Assume the same pgbench configuration as in the previous homework. 

**You must use only SQL statements directly related to the creation/dropping of indexes or table constraints.**
You may include comments with additional information but make sure that the file is a valid SQL script.

### Subtask 1.1 – Indexing for `select_history.sql`

In the first subtask, find the least number of indexes that will allow you to achieve the best performance (TPS) for the `select_history.sql` file.
First, measure the performance of the `select_history.sql` file with the `pgbench` tool.
Then, create the indexes you think will improve its performance.
The TPS must improve roughly **twice** (1.5x minimum) compared to the original performance.
Place the SQL statements you used in the file called `task1-1.sql`.

### Subtask 1.2 – Indexing for `transfer.sql`

Now, consider the indexes you created in the previous subtask.
Benchmark the `transfer.sql` file with the existing indexes.
Can you now improve the performance of the `transfer.sql` file?
Place the SQL statements for this subtask in the file called `task1-2.sql`.

## Task 2 – Optimizing SQL Queries

Before you start with this task, make sure you have cleaned up the database.
Particularly, make sure that you removed all the indexes you created in the previous task.
This can be easily done by running the `../cleanup.sh` script and then running the `../setup.sh` script.
Then you have to populate the database with the data from the `../data/<UCO>.sql` file (see HW1 Task 1).
Now you can continue with the task.

In this task, you will optimize the execution of the following SQL query (`unoptimized.sql`):

```sql
SELECT *
FROM pgbench_accounts a
WHERE a.type='savings' and email like '%@seznam.cz' and created::timestamptz between '2024-01-12 00:00:00' and '2024-01-18 23:59:59';
```

You can use any method you want, as long as the query remains a single SQL statement and returns the same results as the original query.
Either apply the knowledge you have gained from the previous database courses or use any other method to reduce the estimated cost of the select.
(It is possible to reduce it from over 10k to under 100.)
Try to consult the [PostgreSQL documentation](https://www.postgresql.org/docs/current/indexes.html) and find the best practices for the SQL queries you are optimizing.

Place the used SQL commands in the file called `task2-commands.sql`
Place the optimized SQL query (without the explain) in the file called `task2-query.sql`.
After writing the query, run `./generate task2-query` to populate the result file `task2-query.txt`.

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
