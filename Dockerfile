FROM python:3.8-slim-buster

LABEL maintainer=pulakanand@sigmoidanalytics.com

ADD app.py .

RUN pip3 install psutil

CMD ["python" , "app.py"]
