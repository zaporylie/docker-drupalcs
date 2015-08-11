FROM ubuntu:trusty


RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -yq install shunit2 curl php5 php5-curl

RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install git

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && composer global require drupal/coder  

COPY test.sh /tmp/test.sh
RUN chmod +x /tmp/test.sh

RUN mkdir /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null\n" >> /root/.ssh/config

VOLUME /reports

ENV SHA1=HEAD \
 SHA1_BEFORE=HEAD~1 \
 BRANCH=7.x \
 FORMAT=checkstyle \
 DEBUG=FALSE \
 CLONE_URL=https://github.com/drupal/drupal.git

CMD ["/tmp/test.sh"]
