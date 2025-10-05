postgres:
	 docker run -d  --name mypg --network bank-network -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -p 5433:5432 postgres:latest

createdb:
	docker exec -it mypg createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it mypg dropdb  --username=root  simple_bank

# 本地 Docker PostgreSQL 迁移
migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up

# AWS RDS PostgreSQL 迁移（需要设置环境变量）
migrateup-rds:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down 1

# AWS RDS 迁移命令d
migratedown-rds:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1-rds:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

# 查看 RDS 数据库版本
version-rds:
	migrate -path db/migration -database "$(DB_URL)" version

# 修复 RDS dirty 状态
force-rds:
	@read -p "设置版本号: " ver; \
	migrate -path db/migration -database "$(DB_URL)" force $$ver

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go   simplebank/db/sqlc Store
.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 \
        migrateup-rds migratedown-rds migratedown1-rds version-rds force-rds \
        sqlc test server mock