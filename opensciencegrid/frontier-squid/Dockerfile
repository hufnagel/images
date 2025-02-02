# Specify the opensciencegrid/software-base image tag
ARG BASE_OSG_SERIES=3.6
ARG BASE_YUM_REPO=testing

FROM opensciencegrid/software-base:$BASE_OSG_SERIES-el8-$BASE_YUM_REPO

ARG BASE_YUM_REPO=testing

LABEL maintainer OSG Software <help@opensciencegrid.org>

ENV SQUID_CACHE_DIR=/var/spool/squid
ENV SQUID_LOG_DIR=/var/log/squid

# Create the squid user with a fixed GID/UID; do this first, so that the Squid
# install does not do it.  Then do the installs.  All one instruction to reduce
# image size, etc.
RUN groupadd -o -g 10941 squid && \
    useradd -o -u 10941 -g 10941 -s /sbin/nologin -d /var/lib/squid squid && \
    yum update -y && \
    if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
    yum install -y \
                --disablerepo=$yumrepo \
                frontier-squid && \
    rm -rf /var/cache/yum/* && \
    mkdir /etc/squid/customize.d

RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch && \
    > /etc/yum.repos.d/elastic-7.x.repo \
        printf "%s\n" \
        "[elastic-7.x]" \
        "name=Elastic repository for 7.x packages" \
        "baseurl=https://artifacts.elastic.co/packages/7.x/yum" \
        "gpgcheck=1" \
        "gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch" \
        "enabled=1" \
        "autorefresh=1" \
        "type=rpm-md" && \
    if [[ $BASE_YUM_REPO = release ]]; then \
       yumrepo=osg-upcoming; else \
       yumrepo=osg-upcoming-$BASE_YUM_REPO; fi && \
    yum install -y \
                --disablerepo=$yumrepo \
                filebeat && \
    rm -rf /var/cache/yum/*

RUN mkdir -p /var/spool/squid \
 && mkdir -p /var/log/squid \
 && mkdir -p /var/run/squid \
 && mkdir -p /var/cache/squid

RUN chgrp -R 0 /etc/squid \
 && chmod -R g+rwX /etc/squid \
 && chgrp -R 0 /var/spool/squid \
 && chmod -R g+rwX /var/spool/squid \
 && chgrp -R 0 /var/log/squid \
 && chmod -R g+rwX /var/log/squid \
 && chgrp -R 0 /var/run/squid \
 && chmod -R g+rwX /var/run/squid \
 && chgrp -R 0 /var/cache/squid \
 && chmod -R g+rwX /var/cache/squid

COPY squid-customize.sh /etc/squid/customize.sh
COPY customize.d/* /etc/squid/customize.d/
# COPY supervisor-frontier-squid.conf /etc/supervisord.d/40-frontier-squid.conf

USER 10941

EXPOSE 3128

# These env variables can be changed in the container instance
# Set default values which should reflect what is in the RPM
ENV SQUID_IPRANGE="all"
ENV SQUID_CACHE_MEM="128 MB"
ENV SQUID_CACHE_DISK="100000"
ENV SQUID_CACHE_DISK_LOCATION="/var/cache/squid"
ENV SQUID_START_ARGS="--foreground" 

ENTRYPOINT /usr/sbin/fn-local-squid.sh start
