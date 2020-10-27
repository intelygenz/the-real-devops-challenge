FROM python:3.7

WORKDIR /app

COPY app.py requirements.txt ./
COPY src/ /app/src/

RUN pip install -r requirements.txt

RUN addgroup --gid 1000 api && adduser -u 1000 --gid 1000 --shell /bin/sh api

EXPOSE 8080

USER api:api

CMD ["python", "app.py"]
