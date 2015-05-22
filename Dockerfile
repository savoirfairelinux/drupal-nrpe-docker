FROM samos123/drupal
MAINTAINER Frédéric Vachon <frederic.vachon@savoirfairelinux.com>

RUN apt-get update && apt-get install -y vim sudo

RUN apt-get update && \
	apt-get install -y subversion python-setuptools && \
	svn checkout https://github.com/savoirfairelinux/monitoring-tools/branches/drupal/plugins/check-drupal-cache /opt/drupal_cache && \
	apt-get remove -y subversion && \
	cd /opt/drupal_cache && \
	python setup.py develop

RUN apt-get update && \
	apt-get install -y php-pear && \
	pear channel-discover pear.drush.org && \
	pear install drush/drush && \
	drush pm-download site_audit

RUN adduser nagios && adduser nagios www-data
RUN sudo -u nagios drush pm-download site_audit

# Install and configure NRPE
RUN apt-get update && apt-get install -y nagios-nrpe-server supervisor

COPY entrypoint.sh /
COPY etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg