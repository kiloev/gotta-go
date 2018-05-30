# Build image
FROM golang:1.10.2-alpine3.7 AS build
WORKDIR /go/src/app

# Tools to install dependencies
RUN apk add --no-cache git
RUN go get github.com/golang/dep/cmd/dep

# Install dependencies
# Rebuilt only when Gopkg file is updated
COPY Gopkg.lock Gopkg.toml ./
RUN dep ensure -vendor-only

# Build the project
# Rebuilt when any file within project is updated
COPY . .
RUN CGO_ENABLED=0 go build -a -ldflags '-s' -o server

# App image
FROM scratch
WORKDIR /app

# Define entry point
COPY --from=build /go/src/app .
ENTRYPOINT ["./server"]
