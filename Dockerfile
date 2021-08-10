ARG PYTHON_VERSION=3.6
FROM python:${PYTHON_VERSION}-slim

LABEL maintainer "Borja Lopez <borja.lopez@xxxx.com>"

ENV MONGO_URI="mongodb://rest:test@localhost:27888/restaurant"

ENV FLASK_APP="/app/app.py"

WORKDIR /app

COPY ./src/requirements.txt .

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    curl=* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt && \
        rm -rf requirements.txt

COPY [ "./src/app.py", "./src/mongoflask.py", "./" ]

RUN useradd --no-create-home --shell /bin/sh nroot

USER nroot

EXPOSE 8080

ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=8080"]
