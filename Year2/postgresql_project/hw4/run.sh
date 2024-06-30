#!/bin/bash

docker exec pa036 psql -h 127.0.0.1 -p 5432 -U user -d pa036_db -c "SELECT abalance FROM pgbench_accounts WHERE aid IN (1, 2, 3, 4, 5) ORDER BY aid;" &>before.txt

echo "Running the clients"
docker run --rm \
    --network pa036 \
    -v /$(pwd):/app \
    -w /app \
    python:3.10 \
    bash -c 'pip install -r /app/requirements.txt >/dev/null 2>&1 && (python3 client.py --amount 100 --from-account-id 1 --to-account-id 2 >/dev/null & python3 client.py --amount 100 --from-account-id 2 --to-account-id 3 >/dev/null & python3 client.py --amount 100 --from-account-id 3 --to-account-id 4 >/dev/null & python3 client.py --amount 100 --from-account-id 4 --to-account-id 5 >/dev/null & python3 client.py --amount 100 --from-account-id 5 --to-account-id 1 >/dev/null & for job in $(jobs -p); do wait "$job"; done)'

docker exec pa036 psql -h 127.0.0.1 -p 5432 -U user -d pa036_db -c "SELECT abalance FROM pgbench_accounts WHERE aid IN (1, 2, 3, 4, 5) ORDER BY aid;" &>after.txt

DIFFERENCE=$(diff before.txt after.txt)

if [ "$DIFFERENCE" == "" ]; then
    echo "The account balances are the same before and after the transactions."
else
    echo "The account balances are different before and after the transactions:"
    echo "$DIFFERENCE"
fi
