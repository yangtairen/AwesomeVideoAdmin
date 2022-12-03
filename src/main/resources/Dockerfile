FROM jdk_base

EXPOSE 80
WORKDIR /usr/src
VOLUME /usr/src
COPY  . .
ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone;\
    chmod +x *.sh;alias ls='ls -la --color'

CMD ["bash", "-c", "bash start.sh"]
