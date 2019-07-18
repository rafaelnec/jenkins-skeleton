FROM jenkins/jenkins:lts

# if we want to install via apt
USER root

#Install Php
RUN apt-get update && apt-get install -y ca-certificates apt-transport-https 
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get update && apt-get install -y php7.2 php7.2-common php7.2-xml php-xml php-pear php7.2-mbstring php7.2-xdebug php-mbstring pdepend phpmd ant 
RUN pear install PHP_CodeSniffer-3.4.2

# PhpUnit
RUN wget -O phpunit https://phar.phpunit.de/phpunit-8.phar
RUN chmod +x phpunit
RUN mv phpunit /usr/local/bin/phpunit

# PhpLoc
RUN wget https://phar.phpunit.de/phploc.phar
RUN chmod +x phploc.phar
RUN mv phploc.phar /usr/local/bin/phploc

# Phpcpd
RUN wget https://phar.phpunit.de/phpcpd.phar
RUN chmod +x phpcpd.phar
RUN mv phpcpd.phar /usr/local/bin/phpcpd

# Phpdox
RUN wget http://phpdox.de/releases/phpdox.phar
RUN chmod +x phpdox.phar
RUN mv phpdox.phar /usr/local/bin/phpdox
RUN phpdox --version

#Install Php plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

#Install Template
COPY jobs/* $JENKINS_HOME/jobs
RUN chown -R jenkins:jenkins $JENKINS_HOME/jobs/php-template/
RUN chown -R jenkins:jenkins $JENKINS_HOME/jobs/laravel-skeleton/

#switch to jenkins to customize
USER jenkins