FROM python:3.7

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY app.py requirements.txt ./
COPY src/ /app/src/
COPY .venv/ /app/.venv/

RUN addgroup --gid 1000 api && adduser -u 1000 --gid 1000 --shell /bin/sh api

EXPOSE 8080

USER api:api

CMD ["python", "app.py"]
