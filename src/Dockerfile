FROM  golang:1.23.4 as builder

RUN useradd -u 10001 server

WORKDIR /app

COPY main.go go.mod ./

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o server /app/main.go

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd

COPY --chown=server:server html .
COPY --chown=server:server --from=builder /app/server /app/server

USER server
EXPOSE 80
ENTRYPOINT ["/app/server"]
