FROM golang:1.18-alpine as builder

# Setup
RUN mkdir -p /go/src/github.com/developStorm/go-forward-auth
WORKDIR /go/src/github.com/developStorm/go-forward-auth

# Add libraries
RUN apk add --no-cache git

# Copy & build
ADD . /go/src/github.com/developStorm/go-forward-auth/
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a -installsuffix nocgo -o /go-forward-auth github.com/developStorm/go-forward-auth/cmd

# Copy into scratch container
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go-forward-auth ./
ENTRYPOINT ["./go-forward-auth"]
