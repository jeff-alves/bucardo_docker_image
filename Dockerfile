FROM ubuntu:xenial

LABEL maintainer="jefferson@rastrosystem.com.br"
LABEL version="1.0"


RUN { \
    apt -y update; \
    apt -y install bucardo jq libdbix-safe-perl; \
    }

COPY etc/pg_hba.conf /etc/postgresql/9.5/main/
COPY etc/bucardorc /etc/bucardorc
COPY lib/entrypoint.sh /entrypoint.sh

RUN { \
    chmod +x /entrypoint.sh \
    chown postgres /etc/postgresql/9.5/main/pg_hba.conf; \
    chown postgres /etc/bucardorc; \
    chown postgres /var/log/bucardo; \
    mkdir /var/run/bucardo; \
    chown postgres /var/run/bucardo; \
    usermod -aG bucardo postgres; \
    service postgresql start; \
    su - postgres; \
    psql -c "CREATE USER bucardo SUPERUSER PASSWORD 'bucardo';" \
    psql -c "CREATE DATABASE bucardo;" \
    psql -c "GRANT ALL ON DATABASE bucardo TO bucardo;" \
    bucardo install --batch \
    }

VOLUME "/media/bucardo"
CMD ["/bin/bash","-c","/entrypoint.sh"]
