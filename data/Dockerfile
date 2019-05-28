FROM mongo:4.0
ADD restaurant.json /root/restaurant.json
WORKDIR /root
EXPOSE 27017
RUN mkdir /db && \
    mongod --fork --dbpath /db \
           --logpath /var/log/mongodb/mongod && \
    mongoimport --host localhost --db devops_challenge \
                --collection restaurant --type json \
                --file ./restaurant.json && \
    mongod --shutdown --dbpath /db
ENTRYPOINT mongod --sslMode disabled \
                  --bind_ip_all \
                  --dbpath /db
