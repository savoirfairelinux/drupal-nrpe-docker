FROM samos123/drupal
MAINTAINER Frédéric Vachon <frederic.vachon@savoirfairelinux.com>

RUN drush pm-download site_audit

# Install and configure NRPE
RUN apt-get update && apt-get install -y nagios-nrpe-server supervisor
COPY entrypoint.sh /

ENV TERM xterm

