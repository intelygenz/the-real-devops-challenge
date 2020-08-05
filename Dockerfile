FROM debian
COPY the-real-devops-challenge ./api
RUN apt update
RUN apt install virtualenv python-pip -y
RUN pip install tox
RUN cd ./api
RUN virtualenv -p python3 .venv
RUN /bin/bash -c "source .venv/bin/activate"
RUN pip install --no-input -r ./api/requirements.txt 
ENV MONGO_URI=mongodb://intelyAdmin:th3ch4ll3ng3@ntely_mongodb:27017/restaurant?authSource=admin
ENTRYPOINT ["python"]
CMD ["./api/app.py"]
