FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download


COPY ./cmd/app .

COPY /internal ./internal
COPY /db ./db
COPY /translations ./translations

RUN apk update && apk add --no-cache ca-certificates
RUN update-ca-certificates

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /bin/app .

FROM scratch

COPY --from=builder /bin/app /app/app

COPY --from=builder /app/db /db

COPY --from=builder /app/translations /translations

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/


USER 1000

CMD ["/app/app"]