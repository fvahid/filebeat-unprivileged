ARG IMAGE=debian:buster-slim
FROM $IMAGE

RUN set -x \
    && addgroup --system --gid 102 filebeat \
    && adduser --system --disabled-login --ingroup filebeat --no-create-home --home /nonexistent --gecos "filebeat user" --shell /bin/false --uid 102 filebeat \
    && apt-get update \
    && apt-get -y install netbase procps
COPY filebeat-7.6.1-amd64.deb . 
COPY mc . 
RUN dpkg -i filebeat-7.6.1-amd64.deb \
    && chmod 777 -R /etc/filebeat \
    && chmod 777 -R /var/log/ \
    && chmod go-w /etc/filebeat/filebeat.yml \
    && mkdir /var/lib/filebeat \
    && mkdir /.mc/ \
    && chmod 777 -R /var/lib/filebeat \
    && chmod 777 -R /.mc/ \
    && chmod 777 -R /mc

STOPSIGNAL SIGTERM

USER 102
CMD ["filebeat", "-c", "/etc/filebeat/filebeat.yml"]

