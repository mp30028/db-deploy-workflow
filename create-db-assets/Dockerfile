FROM mysql:8.0.29
LABEL maintainer="mp30028" \
      email="mp30028@gmail.com" \
      description="Dockerfile with MySql-Server"
ARG DB_PASSWORD
ARG DB_NAME
ARG SQL_SCRIPT_FILE
#ENV MYSQL_ROOT_PASSWORD P^55word*007
#ENV MYSQL_DATABASE addressbook
ENV MYSQL_ROOT_PASSWORD ${DB_PASSWORD}
ENV MYSQL_DATABASE ${DB_NAME}
#ADD create_db.sql /docker-entrypoint-initdb.d
ADD ${SQL_SCRIPT_FILE} /docker-entrypoint-initdb.d
EXPOSE 3306