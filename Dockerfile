FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt /app/

RUN apk add --no-cache sqlite

RUN pip install --upgrade setuptools

RUN pip install -r requirements.txt

COPY . /app/

EXPOSE 8000