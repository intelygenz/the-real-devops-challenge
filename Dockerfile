FROM python:3.8-alpine

WORKDIR /home/restaurants-app

COPY . /home/restaurants-app

# Create user "app"
# RUN apk update && \
#     echo "app:x:1000:1000:App,,,:/home/restaurants-app:/bin/bash" >> /etc/passwd && \
#     echo "app:x:1000:" >> /etc/group && \
#     chown app:app -R /home/restaurants-app 

# Expect version as build argument
ARG MONGO_URI

RUN pip install -r requirements.txt

# Launch Java application
# USER app:app
RUN chmod +x run.sh
EXPOSE 8080
ENTRYPOINT ["sh","-c","./run.sh"]

