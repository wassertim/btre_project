# DOCKER
docker run --name btre-postgres \
    -v /Users/wassertim/dev/django-course/postgres/data:/var/lib/postgresql/data \
    -e POSTGRES_DB="btredb" \
    -e POSTGRES_PASSWORD="postgres" \
    -e PGDATA="/var/lib/postgresql/data/pgdata" \
    -p 5432:5432 \
    -d postgres
