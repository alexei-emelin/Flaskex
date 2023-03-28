FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install -y python3-minimal
RUN python3 -V
RUN apt-get install -y python3-pip
RUN pip3 install --user --upgrade pip
COPY . /flaskex
WORKDIR /flaskex
RUN pip install -r requirements.txt
CMD python3 app.py
MAINTAINER Alexei Emelin
