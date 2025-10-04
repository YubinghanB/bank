#!/bin/sh

set -e ##任何命令失败立即退出

echo "waiting for postgres to start..."
/app/wait-for.sh postgres:5432 --timeout=60 -- echo "postgres is up"

echo "run db migration"
/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec /app/main
