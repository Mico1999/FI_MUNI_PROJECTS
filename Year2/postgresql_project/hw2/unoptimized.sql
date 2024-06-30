SELECT *
FROM pgbench_accounts a
WHERE a.type='savings' 
      and email like '%@seznam.cz' 
      and created::timestamptz between '2024-01-12 00:00:00' and '2024-01-18 23:59:59';