
FROM python:3.8.16-alpine3.17 as base

RUN mkdir /source
WORKDIR /source
COPY requirements.txt .
RUN pip wheel -r requirements.txt --wheel-dir=/source/wheels

#########################################
FROM python:3.8.16-alpine3.17 as final

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
RUN adduser -u 1000 -g 1000 -h /app flask -D
USER flask
WORKDIR /app
COPY --from=base /source /app
RUN pip install --no-index --find-links=/app/wheels -r requirements.txt
WORKDIR /app
COPY app.py /app/
COPY src /app/src
ENTRYPOINT ["python", "/app/app.py"]