FROM python:3

WORKDIR /opt/app

COPY . .
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "./app.py" ]
