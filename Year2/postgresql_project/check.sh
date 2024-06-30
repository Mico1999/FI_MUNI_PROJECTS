#!/bin/bash

if [ "$(docker inspect -f '{{.State.Running}}' pa036)" = "true" ]; then
    echo "The pa036 container is running."
else
    echo "The pa036 container is not running."
fi
