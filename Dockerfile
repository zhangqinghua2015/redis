# VERSION 0.0.1
# 使用zh121100/tomcat镜像
FROM zh121100/tomcat
# 签名
MAINTAINER qhzhang "zh121100@163.com"

# 安装redis
ADD ./redis-stable.tar.gz  /usr/local
RUN rm /usr/local/redis-stable/redis.conf
ADD ./redis.conf  /usr/local/redis-stable
RUN \
#  cd /tmp && \
#  wget http://download.redis.io/redis-stable.tar.gz && \
#  tar xvzf redis-stable.tar.gz && \
  cd /usr/local/redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /usr/local/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
  mkdir -p /app/Redis/logs && \
  mkdir -p /app/Redis/pid && \
  mkdir -p /app/Redis/working

# Define mountable directories.
#VOLUME ["/data"]

# Define working directory.
#WORKDIR /data

# Define default command.
#CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379

# SSH终端服务器作为后台运行
ENTRYPOINT /usr/sbin/sshd -D
