#Docker file for Pulling image and deploying the application
FROM vishnu4772/test:poc
MAINTAINER Vishnu Vardhan
RUN yum -y install openssh-server passwd supervisor || true
RUN yum clean all
RUN yum install -y wget
