FROM python:3

WORKDIR /pyapp

COPY app.py /pyapp/app.py
COPY src /pyapp/src/
COPY requirements_dev.txt /pyapp/requirements_dev.txt
COPY requirements.txt /pyapp/requirements.txt

RUN pip install -r /pyapp/requirements.txt

EXPOSE 8080

CMD ["python3", "app.py"]