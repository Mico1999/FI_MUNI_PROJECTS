#!/bin/bash
docker run -it --rm -v ".:/hw1" --network pa036 postgres \
    pgbench -h pa036 -p 5432 -U user -d pa036_db -s 3 -T 120 -c 1 -j 1 -f /hw1/insert.sql -n --random-seed=540461;
