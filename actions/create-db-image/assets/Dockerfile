FROM mysql:8.0.29
LABEL maintainer="mp30028" \
      email="mp30028@gmail.com" \
      description="Dockerfile with MySql-Server"
ENV MYSQL_ROOT_PASSWORD P^55word*007
ENV MYSQL_DATABASE addressbook
ADD create_db.sql /docker-entrypoint-initdb.d
EXPOSE 3306