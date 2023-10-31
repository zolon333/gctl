FROM golang:1.19 AS builder
ADD . /src
WORKDIR /src
# Fetch dependencies

# Build image as a truly static Go binary
RUN CGO_ENABLED=0 GOOS=linux GOPROXY=https://goproxy.cn make build

#FROM scratch
#FROM centos:centos7.9.2009
FROM alpine:3.14.2
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
      && apk add --no-cache ca-certificates
COPY --from=builder /src/bin /app
WORKDIR /app

EXPOSE 5040
EXPOSE 5050
EXPOSE 5060
ENTRYPOINT ["./sms"]
#CMD ["-conf", ""]



