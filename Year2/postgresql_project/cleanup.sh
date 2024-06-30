#!/bin/bash

echo "Removing Pg docker container..."

# Kill the postgres instance.
docker kill pa036

# Remove the network.
docker network rm pa036

echo "Everything is cleaned up."
