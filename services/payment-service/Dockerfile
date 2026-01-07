FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod ./
COPY . .
RUN go build -o payment-service .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/payment-service .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8080
CMD ["./payment-service"]
