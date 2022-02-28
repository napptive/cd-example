FROM golang:1.17-alpine as builder

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY cmd/ cmd/

ARG VERSION

RUN echo "Building linux binary, VERSION: ${VERSION}"
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-X main.Version=${VERSION}" -o cd-example ./cmd/main.go

FROM alpine:3.9.4 

COPY --from=builder app/cd-example .
COPY assets assets/

ENTRYPOINT ["./cd-example"]