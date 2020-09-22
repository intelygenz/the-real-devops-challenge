FROM python:3.6-alpine

LABEL MAINTAINER="Jota Bustos"

WORKDIR /app

ADD . /app

RUN pip install -r requirements.txt

EXPOSE 8080

CMD [ "python", "app.py"]