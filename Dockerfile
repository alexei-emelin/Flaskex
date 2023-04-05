FROM python:alpine3.17
COPY . /flaskex
WORKDIR /flaskex
RUN pip install -r requirements.txt
CMD python3 app.py
MAINTAINER Alexei Emelin

