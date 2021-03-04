if ! command -v bucardo &> /dev/null
then
    VERSION="DBIx-Safe-1.2.5"
    wget -nc https://bucardo.org/downloads/${VERSION}.tar.gz
    tar -xzf ${VERSION}.tar.gz
    rm -f ${VERSION}.tar.gz
    cd ${VERSION}
    perl Makefile.PL
    make
    make test
    sudo make install
    cd ..
    rm -rf ${VERSION}
    
    VERSION="Bucardo-5.6.0"
    wget -nc https://bucardo.org/downloads/${VERSION}.tar.gz
    tar -xzf ${VERSION}.tar.gz
    rm -f ${VERSION}.tar.gz
    cd ${VERSION}
    perl Makefile.PL
    make
    sudo make install
    cd ..
    rm -rf ${VERSION}
fi

#sudo systemctl  postgres restart
bucardo -d postgres -U postgres -P password -h localhost -p 2000 --verbose --confirm install
#echo "edit .pgsync.yml file"

bucardo add database <dbname>
#bucardo add all tables`
#bucardo add all sequences`
#bucardo add sync <syncname> type=<synctype> source=<db> targetdb=<db> tables=<table1>,<table2>,...
#bucardo start



docker run --rm --name bucardo -e POSTGRES_PASSWORD=password -p 5000:5432 -d postgres:12
docker run --rm --name bucardo2 -dit ubuntu:xenial
docker exec -it bucardo2 bash

apt -y install bucardo libdbix-safe-perl
apt -y install postgresql-plperl-12
apt -y install libdbi-perl
perl -MCPAN -e 'install DBI'





docker run --rm --name airbyte-destination -e POSTGRES_PASSWORD=password -p 3000:5432 -d postgres:12

docker exec -it airbyte-source psql -U postgres -c "CREATE TABLE users(id SERIAL PRIMARY KEY, col1 VARCHAR(200));"
docker exec -it airbyte-source psql -U postgres -c "INSERT INTO public.users(col1) VALUES('record1');"
docker exec -it airbyte-source psql -U postgres -c "INSERT INTO public.users(col1) VALUES('record2');"
docker exec -it airbyte-source psql -U postgres -c "INSERT INTO public.users(col1) VALUES('record3');"
docker exec -it airbyte-source psql -U postgres -c "select * from users;"
docker exec -it bucardo bash


docker container inspect airbyte-source | grep "\"Source\"\:"
/var/lib/docker/volumes/2cc7c1e0edb3ec6c0ee69891f9991c7bf7b875c77680a178fb1f73aedeb553d4/_data
/var/lib/docker/volumes/43cb9f3d6577502ecd7f8c72f88f51c4534bdafaddba15befad4afffce15120a/_data
