FROM python:3.6.15

ENV MONGO_PREFIX        \
    MONGO_USERNAME      \
    MONGO_USERNAME_PASS \
    MONGO_HOST          \
    MONGO_PORT          \
    APP_DB

WORKDIR /App

COPY --chmod=755 ./ ./

EXPOSE 8080

ENTRYPOINT ["./start.sh"]
