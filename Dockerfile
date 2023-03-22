FROM python:3.6
WORKDIR /usr/src/app
COPY . ./
RUN pip install virtualenv source pymongo[srv]
RUN virtualenv -p python3.6 .venv
CMD [/bin/bash -c source .venv/Scripts/activate]
RUN pip install -r requirements.txt
RUN export MONGO_URI=mongodb+srv://justor7777777:u1jDyDKCzcSoCTo3@cluster0.mxl6ikk.mongodb.net/?retryWrites=true&w=majority
EXPOSE 8080
ENTRYPOINT ["python", "app.py"]