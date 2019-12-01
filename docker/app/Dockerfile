FROM python:3.7-alpine
WORKDIR /workdir
COPY ./requirements.txt /workdir
COPY ./src /workdir/src
COPY ./app.py /workdir/app.py
RUN pip install -r requirements.txt
CMD [ "python", "app.py" ]