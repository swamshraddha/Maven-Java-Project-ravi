FROM tomcat:latest
MAINTAINER Ravikiran

COPY target/*.war /usr/local/tomcat/webapps
