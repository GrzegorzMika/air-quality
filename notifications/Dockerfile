FROM python:3.7-buster

RUN apt-get update && \
    apt-get install mariadb-server -y && \
    apt-get install libv8-dev -y

ENV TZ=Europe/Warsaw

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY requirements.txt /home/pi/notifications/requirements.txt

RUN pip install -r /home/pi/notifications/requirements.txt

RUN mkdir /home/pi/logs

WORKDIR /home/pi/notifications

COPY . .

CMD python main.py