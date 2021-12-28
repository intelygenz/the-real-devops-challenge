FROM python:3.8-slim-buster

ARG USER=flask_user
ARG APP_DIR=/app/src

RUN useradd --user-group -m -d /home/$USER --no-log-init -r $USER

USER $USER

WORKDIR $APP_DIR

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY ./src $APP_DIR

ENV PYTHONPATH $APP_DIR

EXPOSE 8080

ENTRYPOINT python3 app.py