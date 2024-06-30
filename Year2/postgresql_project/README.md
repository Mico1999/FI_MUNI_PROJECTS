# PA036

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- Linux

## Documentation

- [`psql`](https://www.postgresql.org/docs/current/app-psql.html)
- [`pbgench`](https://www.postgresql.org/docs/current/pgbench.html)

## Setup the PostgreSQL instance

```shell
# Start the PostgreSQL instance in a Docker container
./setup.sh
```

After running the `setup.sh` script, you will have a PostgreSQL instance running in a Docker container in the background.
The PostgreSQL instance is running in a Docker container called `pa036` and is accessible on `127.0.0.1` from your host machine or on `pa036` from other Docker containers on port `5432`.
The instance has a database called `pa036_db` and a user called `user`.
No password is required to connect to the instance.

## Is the PostgreSQL instance running?

```shell
# Check if the PostgreSQL instance is running
./check.sh
```

## Connect to the PostgreSQL instance

To connect to the instance, you have two options:

1. You can connect to the instance using `psql` from a Docker container.
The command below will start a new Docker container with the `psql` client and connect to the PostgreSQL instance created by the `setup.sh` script.

```shell
# Connect to the instance using psql from a Docker container
docker run -it --rm --name psql --network pa036 postgres psql -h pa036 -U user -d pa036_db
```

2. Alternatively, you can connect to the instance using `psql` from your host machine.
In that case, you will have to install `psql` on your host machine.

```shell
# Connect to the instance using psql
psql -h 127.0.0.1 -U user -d pa036_db
```

To exit the `psql` client or the Docker container, type `\q` and press `Enter`.

## Cleanup

```shell
# Stop and remove the PostgreSQL instance, all data will be lost
./cleanup.sh
```
