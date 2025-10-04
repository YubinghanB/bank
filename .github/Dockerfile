FROM golang:1.25.1-alpine3.22
WORKDIR /app
COPY . .
RUN go build -o main main.go

EXPOSE 8080

CMD ["/app/main"]