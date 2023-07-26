FROM python:3.6.15

ENV MONGO_USERNAME      \
    MONGO_USERNAME_PASS \
    MONGO_HOST          \
    MONGO_PORT          \
    APP_DB

WORKDIR /App

COPY --chmod=755 ./ ./

ENTRYPOINT ["./start.sh"]
