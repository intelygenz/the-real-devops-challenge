# set base image (host OS)
FROM python:3.9.1-alpine

# set the working directory in the container
WORKDIR /usr/src/app

# copy the dependencies file to the working directory
COPY requirements.txt .

# install dependencies
RUN pip install -r requirements.txt

# copy the content of the local src directory to the working directory
COPY app.py .
COPY src/ ./src

# the api listens on this port
EXPOSE 8080

# run the container as a non-root user
RUN addgroup -S foodie && adduser -S foodie -G foodie
USER foodie

# command to run on container start
CMD [ "python", "app.py" ]
