FROM python:3.9-buster

COPY . . 

RUN pip install Flask gunicorn

# run gunicorn 
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app
