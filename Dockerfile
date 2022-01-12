FROM python:3.8-slim-buster

ARG USER=flask_user
ARG APP_DIR=/app/src

RUN apt-get update && apt-get upgrade -y

RUN useradd --user-group -m -d /home/$USER --no-log-init -r $USER

WORKDIR $APP_DIR

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY ./src $APP_DIR

ENV PYTHONPATH $APP_DIR

USER $USER

EXPOSE 8080

ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=8080"]
