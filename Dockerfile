#build stage
FROM golang:alpine AS builder
RUN apk add --no-cache git
WORKDIR /go/src/app
COPY . .
RUN go get -d -v ./...
RUN go build -o /go/bin/app -v ./cmd/atomic

#final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/bin/app /app
COPY --from=builder /go/src/app/config/prod/config.prod.yaml /config.yaml
ENTRYPOINT /app
LABEL Name=atomic Version=0.0.1