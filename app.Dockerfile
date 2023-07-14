FROM python:3.12.0b4-alpine3.18

WORKDIR ./app
# install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt
# copy app code
COPY ./app.py .
COPY ./src/* ./src/
# expose port where app runs
EXPOSE 5000
# pass MONGO_URI
ENV MONGO_URI="mongodb+srv://[USER]:[PASSWORD]@cluster0.26oiqds.mongodb.net/restaurant"

CMD ["flask", "run", "--host", "0.0.0.0"]