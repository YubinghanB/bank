#!/bin/sh

set -e ##任何命令失败立即退出

# 从 DB_SOURCE 提取主机名和端口
DB_HOST=$(echo "$DB_SOURCE" | sed -n 's|.*@\([^:]*\):[0-9]*.*|\1|p')
DB_PORT=$(echo "$DB_SOURCE" | sed -n 's|.*@[^:]*:\([0-9]*\).*|\1|p')

echo "Database host: $DB_HOST"
echo "Database port: $DB_PORT"

# 如果是本地 postgres 主机名，等待数据库启动
if [ "$DB_HOST" = "postgres" ]; then
    echo "Waiting for local postgres to start..."
    /app/wait-for.sh postgres:5432 --timeout=60 -- echo "postgres is up"
else
    echo "Connecting to remote database (RDS), skipping wait..."
fi

echo "run db migration"
/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec /app/main
