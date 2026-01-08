FROM golang:1.21-alpine AS builder
WORKDIR /services/payment-service
COPY go.mod ./
COPY . .
RUN go build -o payment-service .

FROM alpine:latest
WORKDIR /services/payment-service       
COPY --from=builder /services/payment-service .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8080
CMD ["./payment-service"]
