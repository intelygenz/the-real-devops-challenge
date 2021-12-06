# Solutions

The following are the solutions to the overall exercises within the repository that are bing added to the answer branch.  

## Challenge 1

For challenge 1, I fied the following two files:

```bash
./src/mongoflask.py
app.py
```

Basically, I found a typo within `mongoflask.py`

```bash
query["_id"] = ObjectId(id) it should have been query["_id"] = ObjectId(_id)
```

Afterwards, I was able to get the response.

## Challenge 2

For the second challenge, I made a `Jenkinsfile` and tied it up to one of my Jenkins personal pipelines to see if it would work. It runs through the Makefile that sits in the root of the directory to build the container image, test it, scan it with snyk, and then test to see if the container actually runs. I also started on a CircleCI implementation, but I prefer Jenkins so I just set up the initial configuration to do a CircleCI implementation. 

## Challenge 3

I dockerized the repository pulling from a python base image, I started out trying to use Ubuntu and Build from source, but ended up with just a python based image for the sake of simplicity. 

```bash
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
```

What the `Dockerfile` does:

- Base Image for Python Application
- Sets the working directory 
- Copys over the requirements.txt file
- Installs requirements with pip3
- Copies everything over in the current working directory into the `/code` directory
- Sets the initial command with the ENTRYPOINT for the python `app.py` application that was copied over. 

## Challenge 4 && Challenge 5

To accomplis this task I used the Makefile to make the image locally and then implemented both within a docker-compose.yml file so that I could spin up all of the required resourced.

## Challenge 6

For this aspect I used a Kubernetes Tool called `Kompose` this allows me to actually create all of the required resources (I.e. Kubernetes Manifest Files) for an implementation to move it over into a Kubernetes Deployment.
All of the resources were created within the root directory. They still maintain all of the `kompose` labels and basic metadata. While it can be deleted, I left it in there for posterity to showcase `Kompose` tooling.
While sitting in the current working directory you can use:

```bash
kubectl apply -f . 
```

It will deploy using your local Kubeconfig.
