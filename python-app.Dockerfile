FROM python:3.9-alpine

WORKDIR /opt/python-app
COPY requirements.txt .

RUN pip install --upgrade pip --no-cache-dir
RUN pip install -r requirements.txt --no-cache-dir

COPY app.py .
COPY ./src ./src/

EXPOSE 8080

CMD ["python3", "-u", "app.py"]

