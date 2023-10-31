FROM centos:centos7.9.2009
MAINTAINER loqi <loqi4650@gmail.com>
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
      echo "Asia/Shanghai" > /etc/timezone
COPY build/bin/workorder /app/
WORKDIR /app

EXPOSE 5040
EXPOSE 5050
EXPOSE 5060
ENTRYPOINT ["./workorder"]
#CMD ["-conf", ""]



