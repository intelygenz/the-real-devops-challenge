FROM mongo

COPY restaurant.json /restaurant.json
COPY setup.sh /docker-entrypoint-initdb.d

RUN chmod +x /docker-entrypoint-initdb.d/setup.sh
