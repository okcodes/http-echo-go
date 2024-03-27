FROM golang:alpine AS builder
WORKDIR /app
# Our app is so small we don't even need to download dependencies.
# COPY go.mod go.sum ./
# RUN go mod download
# COPY . .
COPY main.go go.mod ./
RUN go build -o server .

FROM alpine AS app

ARG APP_VERSION=local
ARG APP_BUILD=local

ENV APP_VERSION=${APP_VERSION}
ENV APP_BUILD=${APP_BUILD}

COPY --from=builder /app/server /server
EXPOSE 8080

CMD ["/server"]

# docker build --build-arg APP_VERSION=0.0.0 --build-arg APP_BUILD=0.0.0-build -t okcodes/http-echo-go:latest -t okcodes/http-echo-go:0.0.0 .

# Cross-Architexture Compilation
# docker buildx build --platform "linux/arm64,linux/amd64,linux/arm64/v8" --build-arg APP_VERSION=0.0.0 --build-arg APP_BUILD=0.0.0-build -t okcodes/http-echo-go:latest -t okcodes/http-echo-go:0.0.0 .

# docker run -it --rm -p 8080:8080 -e PORT=8080 http-echo-go

# docker login -u okcodes
# docker push okcodes/http-echo-go:latest
# docker push okcodes/http-echo-go:0.0.0
