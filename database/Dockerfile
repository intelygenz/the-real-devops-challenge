FROM mongo:6.0.8

ENV MONGO_HOST      \
    MONGO_PORT      \
    ROOT_USERNAME   \
    ROOT_PASSWORD   \
    AUTH_DB         \
    APP_DB

COPY ./collections/restaurant.json ./collections/restaurant.json

COPY ./start.sh ./

RUN chmod +x /start.sh

CMD ["/start.sh"]