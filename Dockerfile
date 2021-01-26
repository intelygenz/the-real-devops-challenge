# Use  Centos8 as base image
FROM centos:centos8

# Maintainer of the Dockerfile
LABEL maintainer "Alejandro Aceituna Cano - IGZ Devops Team <devops@intelygenz.com>"

# Environment variables
ENV MONGO_URI="mongodb://igz:test@127.0.0.1:27017/restaurant" \
    FLASK_APP="/deployments/app.py"
    ENV TZ=Europe/Madrid

# Switch to ROOT user
USER root

#  Set the time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install required packages, but skip the man pages
RUN yum -y --setopt=tsflags=nodocs install \
   python36 gettext

# Install Python libs
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy python scripts
COPY src/app.py /deployments/app.py
COPY src/mongoflask.py /deployments/mongoflask.py

# Set +x to app.py
RUN chmod 755 /deployments/app.py

# Run container as non-root user
RUN useradd --no-create-home --shell /bin/sh nroot
USER nroot

# Expose the microservice port
EXPOSE 8080

# Set entrypoint
ENTRYPOINT ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=8080"]