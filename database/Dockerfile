FROM mongo:6.0.8

ENV MONGO_HOST      \
    MONGO_PORT      \
    ROOT_USERNAME   \
    ROOT_PASSWORD   \
    AUTH_DB         \
    APP_DB

WORKDIR /data

COPY --chmod=755 ./entrypoint.sh ./

COPY ./collections/restaurant.json collections/restaurant.json

ENTRYPOINT ["./entrypoint.sh"]