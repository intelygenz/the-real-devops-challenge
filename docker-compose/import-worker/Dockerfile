FROM mongo:latest

ARG MONGO_PASS
COPY restaurant.json /tmp/restaurant.json
WORKDIR /tmp

CMD mongoimport --host mongodb --db admin --collection restaurant --type json --file restaurant.json --username abg --password ${MONGO_PASS} --authenticationDatabase admin