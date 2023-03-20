FROM ghcr.io/linuxserver/baseimage-rdesktop-web:3.17

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SIGNAL_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
  echo "**** install packages ****" && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk update && \
  if [ -z ${SIGNAL_VERSION+x} ]; then \
    SIGNAL_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/edge/testing/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:signal-desktop$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --force-overwrite --no-cache \
    signal-desktop==${SIGNAL_VERSION} && \
  echo "**** postprocessing ****" && \
  sed -i 's|</applications>|  <application title="Signal Desktop" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
