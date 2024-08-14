# 使用 Alpine 镜像  
FROM alpine  

# 环境变量  
ENV CRON_PATH=/etc/crontabs  
ENV HOST=0.0.0.0  
ENV PORT=8000  
ENV CRON_IN_DOCKER=true  

# 创建目录和文件  
RUN mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root  

# 设置工作目录  
WORKDIR /crontab-ui  

# 标签信息  
LABEL maintainer="@qiruizheng"  
LABEL description="Crontab-UI docker"  

# 安装必要的包  
RUN apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata \
      openntpd  

# 设置时区为 UTC+8  
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone  

# 拷贝配置文件  
COPY supervisord.conf /etc/supervisord.conf  
COPY . /crontab-ui  

# 安装 npm 依赖  
RUN npm install  

# 开放端口  
EXPOSE $PORT  

# 启动 supervisord 和 ntpd  
CMD ["sh", "-c", "ntpd -d && supervisord -c /etc/supervisord.conf"]
