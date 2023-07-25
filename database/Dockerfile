FROM mongo:6.0.8

COPY ./collections/restaurant.json ./collections/restaurant.json

COPY ./start.sh ./setupUsers.js ./

RUN chmod +x /start.sh

CMD ["/start.sh"]