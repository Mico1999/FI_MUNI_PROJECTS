#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <aid> <start_date> <end_date>"
    exit 1
fi

docker run --rm \
    --network pa036 \
    -v /$(pwd):/app \
    -w /app \
    python:3.10 \
    bash -c "echo 'Installing dependencies' && pip install -r /app/requirements.txt >/dev/null 2>&1 && echo 'Running generate_statement_file.py' && python3 generate_statement_file.py --account-id $1 --start $2 --end $3"
