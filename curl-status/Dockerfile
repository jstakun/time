FROM registry.redhat.io/ubi7/ubi

MAINTAINER Jaroslaw Stakun <jstakun@redhat.com>

ARG DOMAIN=www.google.com
ENV JAMES_HOME=/opt/james DOMAIN=${DOMAIN}

WORKDIR $JAMES_HOME

USER root

RUN adduser -g 0 -c "James user" -p james james && \
    mkdir -p $JAMES_HOME

COPY ./status.sh $JAMES_HOME

RUN chown james:root $JAMES_HOME && chmod +x $JAMES_HOME/status.sh

USER james

#ENTRYPOINT ["/opt/james/status.sh"]
ENTRYPOINT ["/opt/james/status.sh"]
