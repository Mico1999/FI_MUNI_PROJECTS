#!/bin/bash

docker run --rm \
    --network pa036 \
    -v /$(pwd):/app \
    -w /app \
    python:3.10 \
    bash -c 'echo "Installing dependencies" && pip install -r /app/requirements.txt >/dev/null 2>&1 && echo "Running student.py" && python3 student.py'
