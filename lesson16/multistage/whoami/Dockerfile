FROM golang:1.24-alpine AS build
WORKDIR /src
RUN apk add --no-cache git
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/whoami .

FROM alpine:latest
RUN adduser -D -u 10001 whoami
COPY --from=build /out/whoami /usr/local/bin/whoami
EXPOSE 80
USER whoami
ENTRYPOINT ["whoami"]
