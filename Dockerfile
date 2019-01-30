from alpine:3.8

LABEL autor Oleg Blazhyievskyi <oleg.blazhyievskyi@gmail.com>

WORKDIR /app
COPY app.py /app/app.py
COPY requirements.txt /app/requirements.txt
COPY src /app/src/
RUN apk --no-cache add python3 && pip3 install -r requirements.txt && rm /app/requirements.txt

CMD ["python3", "app.py"]