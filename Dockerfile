FROM python:3.7.4

WORKDIR /code

COPY requirements.txt .

LABEL maintainer="Richard Barrett richard-barrett@outlook.com"

# Install updates to base image
# RUN apt-get update -y && apt-get install -y
#RUN apt-get clean
 
# Install Python and Software Dependencies
#RUN apt-get install python3 -y
#RUN apt install python3-pip -y
#RUN python3 -m pip install --user virtualenv

# Install and Set-Up Virtual Environment 
#RUN virtualenv -p python3 .venv
#RUN source .venv/bin/activate

# Install; Requirements Recursively
RUN pip3 install -r requirements.txt 

COPY . /code



ENV LC_ALL=C.UTF8
ENV LANG=C.UTF-8

ENTRYPOINT [ "python3", "./app.py" ]


