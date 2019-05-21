FROM python:3.6
ADD . /root/app
WORKDIR /root/app
EXPOSE 8080
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENTRYPOINT ["python","app.py"]
