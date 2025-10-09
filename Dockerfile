# Build stage
FROM golang:1.25.1-alpine3.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build  -ldflags="-w -s" -o main main.go

## Run Stage
FROM alpine:3.22
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .
COPY db/migration ./db/migration
COPY start.sh .
COPY wait-for.sh .
RUN chmod +x /app/start.sh /app/wait-for.sh

EXPOSE 8080 9090
CMD ["/app/start.sh"]