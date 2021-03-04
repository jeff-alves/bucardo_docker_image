FROM ubuntu:xenial

LABEL maintainer="jefferson@rastrosystem.com.br"
LABEL version="1.0"


RUN { \
    apt-get -y update; \
    apt-get -y install bucardo jq libdbix-safe-perl; \
    }

COPY files/pg_hba.conf /etc/postgresql/9.5/main/
COPY files/bucardorc /etc/bucardorc
COPY files/entrypoint.sh /entrypoint.sh

RUN { \
    chmod +x /entrypoint.sh; \
    chown postgres /etc/postgresql/9.5/main/pg_hba.conf; \
    chown postgres /etc/bucardorc; \
    chown postgres /var/log/bucardo; \
    mkdir /var/run/bucardo; \
    chown postgres /var/run/bucardo; \
    usermod -aG bucardo postgres; \
    service postgresql start; \
    psql -U postgres -c "CREATE USER bucardo SUPERUSER PASSWORD 'bucardo';"; \
    psql -U postgres -c "CREATE DATABASE bucardo;"; \
    psql -U postgres -c "GRANT ALL ON DATABASE bucardo TO bucardo;"; \
    bucardo install --batch; \
    }

VOLUME "/media/bucardo"
CMD ["/bin/bash","-c","/entrypoint.sh"]
