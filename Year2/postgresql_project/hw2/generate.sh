#!/bin/bash

TASK=$1

if [ "$TASK" != "task2-query" ]; then
    echo "Invalid task number"
    exit 1
fi

RESULT=$(docker run --rm --network pa036 -v "./${TASK}.sql:/${TASK}.sql" postgres psql -h pa036 -U user -d pa036_db -f "/${TASK}.sql")
echo "${RESULT}" >"${TASK}.txt"
