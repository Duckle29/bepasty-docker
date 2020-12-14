FROM alpine
MAINTAINER Mikkel Jeppesen

# Thanks to https://grrr.tech/posts/2020/add-locales-to-alpine-linux-docker-image/ for locales in alpine


ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl
ENV UWSGI_DEPS linux-headers gcc

RUN apk add --no-cache \
    py3-pip python3-dev git\
    $MUSL_LOCALE_DEPS \
    $UWSGI_DEPS

# Set up musl-locale
RUN wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
    && cd musl-locales-master \
    && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . \
    && make \
    && make install \
    && cd .. \
    && rm -r musl-locales-master

RUN pip3 install uwsgi
RUN pip3 install -e git+https://github.com/bepasty/bepasty-server.git#egg=bepasty-server

# Set the locale
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

VOLUME /srv/bepasty
ENV BEPASTY_CONFIG /srv/bepasty/bepasty.conf
ENV PYTHONUNBUFFERED 0
EXPOSE 5000

WORKDIR /opt

ADD start.sh /opt/start.sh
ADD bepasty.conf.template /opt/bepasty.conf.template
ADD wsgi.py /opt/wsgi.py
RUN chmod 550 /opt/start.sh

CMD ["/opt/start.sh"]
