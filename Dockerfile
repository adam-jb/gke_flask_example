FROM python:3.9-buster

COPY . . 

RUN pip3 install -r requirements.txt


ENTRYPOINT FLASK_APP=app.py flask run --host=0.0.0.0