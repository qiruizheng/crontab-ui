# docker run -d -p 8000:8000 qiruizheng/crontab-ui
FROM alpine

ENV   CRON_PATH=/etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui

LABEL maintainer="@qiruizheng"
LABEL description="Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   npm install

ENV   HOST=0.0.0.0

ENV   PORT=8000

ENV   CRON_IN_DOCKER=true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
