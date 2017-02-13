FROM jkirkby91/ubuntusrvbase:latest

MAINTAINER James Kirkby <jkirkby91@gmail.com>

RUN groupadd -r beanstalkd && useradd -r -g beanstalkd beanstalkd

# Install packages specific to our project
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y beanstalkd --force-yes --fix-missing --no-install-recommends && \
apt-get remove --purge -y software-properties-common build-essential && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_* && \
rm -rf /var/lib/apt/lists/*

EXPOSE 11300

COPY confs/apparmor/beanstalkd.conf /etc/apparmor/beanstalkd.conf

COPY confs/supervisord/supervisord.conf /etc/supervisord.conf

COPY start.sh /start.sh

RUN chmod 777 /start.sh && \
mkdir -p /srv/log/supervisor/ && \
touch /srv/log/supervisor/beanstalkd.log && \
chown beanstalkd:beanstalkd /srv

VOLUME /srv

WORKDIR /srv

USER beanstalkd

CMD ["/bin/bash", "/start.sh"]