#  Copyright (c) bigdataplot LLC
#  Distributed Under GNU GENERAL PUBLIC LICENSE

## ========== Begin-Of-Dockerfile ==========
## Build Base
FROM ubuntu:trusty


## Base Update
RUN umask 022
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git php5 python-dev python-setuptools python-pip supervisor ssh-client


## Tag
MAINTAINER Yongjian(Ken) Ouyang <yongjian.ouyang@outlook.com>


## Create/Change App Directory
RUN mkdir -p /apps/jobs/log/
WORKDIR /apps


## Install Packages
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade j2cli
RUN git clone https://github.com/mlazarov/supervisord-monitor.git


## Change Working Directory
WORKDIR /apps/supervisord-monitor


## File Transfer / Fix Permission
COPY supervisord.php.j2 supervisord.php.j2
COPY welcome.php.j2 welcome.php.j2
COPY start_monitor.sh start_monitor.sh
COPY py_job_process.conf py_job_process.conf
COPY py_job_test.py py_job_test.py

RUN chmod 511 start_monitor.sh && \
    chmod 511 supervisord.php.j2 && \
    chmod 511 welcome.php.j2


## Cleaning
RUN apt-get remove -y wget software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean -y


## Environment Configuration
EXPOSE 80

ENV PORT 9001
ENV CONTACT_EMAIL none@none.com
ENV SERVER_NAME "Procedure Support Center"


## Run
CMD bash /apps/supervisord-monitor/start_monitor.sh


## ========== End-Of-Dockerfile ==========