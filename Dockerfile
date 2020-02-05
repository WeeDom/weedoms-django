FROM python:3.7
LABEL MAINTAINER="Flowmo.co"

ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN apt-get update && apt-get install -y python-dev python3-dev default-libmysqlclient-dev apache2 apache2-utils ssl-cert libapache2-mod-wsgi-py3 locales
RUN pip install --upgrade pip
COPY ./requirements.txt /requirements.txt
RUN pip install wheel
RUN pip install -r /requirements.txt

ENV APACHE_CONFDIR=/etc/apache2
ENV APACHE_ENVVARS="$APACHE_CONFDIR/envvars"
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_PID_FILE="$APACHE_RUN_DIR/apache2.pid"
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
ENV ALLOWED_HOST=localhost

ADD ./docker/apache/conf/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN chown -R www-data:www-data /app

# Currently not running, need help with this.
# RUN python manage.py collectstatic --noinput

ENV SECRET_KEY=secretkey

CMD ["apache2", "-DFOREGROUND"]

######## DEV ########

# FROM flowmoco/invictus-wis-api:latest
# LABEL MAINTAINER="Dan Streeter <dan@flowmo.co>"

# Install Development Dependancies (ptvsd remote debugger)
# RUN pip install ptvsd
