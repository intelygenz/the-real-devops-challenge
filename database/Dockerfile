FROM mongo:6.0.8

ENV MONGO_HOST      \
    MONGO_PORT      \
    ROOT_USERNAME   \
    ROOT_PASSWORD   \
    AUTH_DB         \
    APP_DB

COPY ./ ./

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]