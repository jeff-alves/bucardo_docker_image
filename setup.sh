docker network create --driver=bridge n1

nano bucardo/bucardo.json
docker build -t jeff/bucardo .
docker run --network=n1 --name bucardo -v ./bucardo:/media/bucardo -d jeff/bucardo

docker run --rm --network=n1 --name fonte -e POSTGRES_PASSWORD=admin123 -p 2000:5432 -d postgres:12
docker run --rm --network=n1 --name destino -e POSTGRES_PASSWORD=admin123 -p 3000:5432 -d postgres:12

docker exec -it fonte psql -U postgres -c "CREATE DATABASE mydb;"
docker exec -it fonte psql -U postgres -d mydb -c "CREATE TABLE users(id SERIAL PRIMARY KEY, col1 VARCHAR(200));"
docker exec -it fonte psql -U postgres -d mydb -c "INSERT INTO public.users(col1) VALUES('record1');"
docker exec -it fonte psql -U postgres -d mydb -c "INSERT INTO public.users(col1) VALUES('record2');"
docker exec -it fonte psql -U postgres -d mydb -c "INSERT INTO public.users(col1) VALUES('record3');"
docker exec -it fonte psql -U postgres -d mydb -c "select * from users;"


docker exec -it bucardo bash
