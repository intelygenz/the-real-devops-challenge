FROM mongo:4.4.10

COPY ./config_scripts/mongo-user.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/mongo-user.sh