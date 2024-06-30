#!/bin/bash

PORT=${1:-5432}

# Test for an app running on the port:
netstat -tuln | grep -q $PORT
if [ $? -eq 0 ]; then
	echo "There is a service running of the port $PORT. Please use a different port number or stop the service."
	echo "$0 <port>"
	exit 1
fi

# Create a new network for the postgres instance so that you can connect to it from other containers.
docker network create pa036

# Run the postgres instance.
echo "Starting Pg on port $PORT..."
docker run --rm -d \
    --name pa036 \
    --network pa036 \
    -e POSTGRES_USER=user \
    -e POSTGRES_HOST_AUTH_METHOD=trust \
    -p 127.0.0.1:$PORT:5432 \
    postgres

# Wait for the postgres instance to start.
echo "Waiting for Pg to start..."
sleep 5

# Create the database for benchmarking.
echo "Creating a benchmarking database..."
docker run -it --rm --network pa036 postgres \
    psql -h pa036 -p 5432 -U user -d postgres -c "CREATE DATABASE pa036_db;"

echo "Everything is set up. You can now run the tests."
echo "Hints:"
echo "   1/ At anytime, use 'docker container list' to check running containters."
echo "   2/ To connect to Pg: psql -h localhost -p $PORT -U user -d pa036_db"
echo "   2/ or:               docker run -it --rm --name psql --network pa036 postgres psql -h pa036 -U user -d pa036_db"

