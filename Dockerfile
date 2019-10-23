FROM python:alpine3.10

WORKDIR /app

ADD requirements.txt /app/

RUN pip3 install --no-cache-dir -r requirements.txt

COPY src /app/src
ADD app.py /app/

EXPOSE 8080
CMD [ "python3", "app.py" ]