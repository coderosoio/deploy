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
                    /coderoso/coderoso
COPY --from=builder /coderoso/web/static \
                    /coderoso/static
COPY --from=builder /coderoso/web/template \
                    /coderoso/template
COPY --from=builder /coderoso/web/config.yml \
                    /coderoso/config.yml
COPY --from=builder /coderoso/web/config.production.yml \
                    /coderoso/config.production.yml

ENV APP_ENV=production

EXPOSE 3000

CMD ["./coderoso", "-c config.yml"]
