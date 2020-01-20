FROM python:3.7-slim-buster

# install free-tds used for MSSQL connections
RUN sed -i "s#deb http://security.debian.org/debian-securitystretch/updates main#deb http://deb.debian.org/debian-security stretch/updates main#g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y g++
RUN apt-get install -y unixodbc-dev
RUN apt-get install -y freetds-dev
RUN apt-get install -y freetds-bin
RUN apt-get install -y tdsodbc

# create a freetds odbc driver path
# required so python scripts can reference {FreeTDS} in their pypyodbc connections
RUN echo "[FreeTDS]" >> /etc/odbcinst.ini
RUN echo "Description=FreeTDS Driver" >> /etc/odbcinst.ini
RUN echo "Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so" >> /etc/odbcinst.ini
RUN echo "Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so" >> /etc/odbcinst.ini

RUN apt-get clean

COPY requirements.txt .
RUN pip install --default-timeout=2000 --no-cache-dir -r requirements.txt

COPY example.py .

# set entrypoint
ENTRYPOINT python example.py
