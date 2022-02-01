FROM python:3.10.2-slim-buster
ADD app.py .
RUN pip3 install psutil
EXPOSE 5001
CMD ["python" , "./app.py"]

