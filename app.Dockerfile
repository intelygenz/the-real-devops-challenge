FROM python:3.9.0-alpine3.12

# Versioning
LABEL version=1.0.0

# Versioning description
LABEL description="FLASK APP | intelygenz/the-real-devops-challenge by Martín Vedani"

# Maintainer
LABEL maintainer="Martín Vedani <martin.vedani@gmail.com>"

# Make the working directory for subsequent commands
WORKDIR /opt/flask

# Place the application components in a dir below the root dir
ADD requirements.txt .

# Install requirements.txt and CLEAN UP
RUN pip install --upgrade pip --no-cache-dir &&\
  pip install -r requirements.txt --no-cache-dir &&\
  rm requirements.txt

# Copy app and mongo scripts
COPY app.py .
COPY ./src ./src/

# We don't want to run our application as root if it is not strictly necessary, even in a container.
# Create a user and a group called 'flask' to run the processes.
# A system user is sufficient and we do not need a home.
RUN addgroup flask && adduser -D flask -G flask

# Hand everything over to the 'app' user
RUN chown -R flask:flask /opt/flask

# Subsequent commands will run as user 'app'
USER flask

# Expose port
EXPOSE 8080

# Export variables
ENV MONGO_URI=mongodb://flask_user:flask_passwd@mongodb:27017/restaurant?authSource=restaurant

# Run the app
CMD ["python3", "-u", "app.py"]
