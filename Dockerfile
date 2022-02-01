FROM python:3.8-slim-buster

LABEL maintainer=pulakanand@sigmoidanalytics.com

ADD app.py .

RUN pip3 install psutil

EXPOSE 5000

CMD ["python" , "app.py"]

