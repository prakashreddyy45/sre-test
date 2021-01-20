FROM python:3

WORKDIR /usr/src/app

COPY app.py ./
RUN pip install --no-cache-dir flask

ENV MY_NAME=Prakash
CMD [ "python", "./app.py" ]
