# (tested python > 300MB, python-slim 191 MB, and finally alpine 65 MB)
FROM alpine:latest   
RUN apk add --no-cache python3 

WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

COPY app.py /app/app.py
COPY src /app/src/

EXPOSE 8080

CMD ["python3", "app.py"]
