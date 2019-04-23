FROM golang:latest AS builder

COPY . /coderoso

WORKDIR /coderoso/web

ENV GOOS=linux \
    CGO_ENABLED=0 \
    GO111MODULE=on \
    APP_ENV=production

RUN go mod download
RUN go build -o cmd/web/coderoso cmd/web/*.go

FROM alpine:latest

WORKDIR /coderoso

COPY --from=builder /coderoso/web/cmd/web/coderoso \
                    /coderoso/web/static \
                    /coderoso/web/template \
                    /coderoso/web/config.yml \
                    /coderoso/web/config.production.yml \
                    /coderoso/

EXPOSE 3000

CMD ["./coderoso", "-c config.yml"]
