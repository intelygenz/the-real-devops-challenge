FROM python:3.7-slim as builder
COPY requirements.txt /opt/requirements.txt
RUN python3 -m venv /opt/.venv
RUN /opt/.venv/bin/pip install --upgrade pip
RUN /opt/.venv/bin/pip install -r /opt/requirements.txt

FROM python:3.7-slim
COPY --from=builder /opt/.venv /opt/.venv
ENV MONGO_URI mongodb://abg:Ch4ng3m3pl34s3!@localhost:27017/admin
WORKDIR /opt/myapp
COPY src src/.
COPY app.py .
CMD ["/opt/.venv/bin/python3", "app.py"]
