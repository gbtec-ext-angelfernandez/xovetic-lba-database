FROM postgres:9.4

ENV POSTGRES_USER=lba \
    POSTGRES_PASSWORD=lb4Us3r \
    POSTGRES_MAX_CONNECTIONS=200 \
    POSTGRES_SHARED_BUFFERS="256MB"

COPY install-crontab.sh entrypoint.sh /startup/
COPY backup/*.sh /var/lib/postgresql/

ADD ./scripts/ /docker-entrypoint-initdb.d/

RUN chown -R postgres:postgres /docker-entrypoint-initdb.d/

RUN chmod +x /var/lib/postgresql/*.sh && \
    chmod +x /startup/*.sh && \
    mkdir -p /var/lib/postgresql/backup && \
    chown -R postgres:postgres /var/lib/postgresql && \
    apt-get update && \
    apt-get install -y dos2unix && \
    apt-get install -y cron less vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER postgres

ENTRYPOINT ["/startup/entrypoint.sh"]
CMD ["database-with-backup"]

USER root