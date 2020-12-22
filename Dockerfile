FROM vcxpz/baseimage-alpine

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Fork of Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Alex Hyde"

RUN \
 echo "**** install curl ****" && \
 apk add --no-cache \
	curl && \
 curl https://alpine.spritsail.io/spritsail-alpine.rsa.pub -o /etc/apk/keys/spritsail-alpine.rsa.pub && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
     libmediainfo \
     sqlite-libs && \
 apk add --no-cache --repository https://alpine.spritsail.io/mono \
     mono-runtime && \
 echo "**** fix certs ****" && \
 cert-sync /etc/ssl/certs/ca-certificates.crt && \
 echo "**** cleanup ****" && \
 rm -rf \
     /etc/apk/keys/spritsail-alpine.rsa.pub \
     /tmp/*
