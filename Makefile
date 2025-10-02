postgres:
	 docker run -d  --name mypg -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -p 5433:5432 postgres:latest

createdb:
	docker exec -it mypg createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it mypg dropdb  --username=root  simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down


sqlc:
	sqlc generate
.PHONY: postgres createdb dropdb migrateup migratedown sqlc