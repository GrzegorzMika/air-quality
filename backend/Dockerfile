FROM raspbian/stretch
FROM arm32v7/python:3.5-buster

ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_HOST

RUN apt-get update && \
    apt-get install libpython3.5 build-essential swig3.0 cmake libjson-c-dev -y

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y nodejs-dev

RUN cd /tmp && \
        git clone https://github.com/intel-iot-devkit/mraa && \
        cd mraa && \
        mkdir build && \
        cd build && \
        cmake .. && \
        make && \
        make install

ENV TZ=Europe/Warsaw

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "deb https://seeed-studio.github.io/pi_repo/ stretch main" | tee /etc/apt/sources.list.d/seeed.list

RUN curl https://seeed-studio.github.io/pi_repo/public.key | apt-key add -

RUN apt-get update && apt install python-mraa python-upm python-rpi.gpio -y

COPY requirements.txt /home/pi/database/requirements.txt

RUN pip install -r /home/pi/database/requirements.txt

RUN git clone https://github.com/Seeed-Studio/grove.py

WORKDIR grove.py

RUN pip install .

COPY seeed_dht.py seeed_dht.py

RUN mkdir /home/pi/logs

WORKDIR /home/pi/database

COPY . .

CMD python main.py
