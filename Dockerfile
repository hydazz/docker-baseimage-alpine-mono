FROM vcxpz/baseimage-alpine

RUN \
 echo "**** Install Build Packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
  libgcc \
  g++ \
  make \
  python3 \
  autoconf \
  automake \
  libtool \
  musl-dev \
  cmake \
  linux-headers \
  gdb \
  strace \
  git \
  linux-headers && \
 echo "**** Install Runtime Packages ****" && \
 apk add --no-cache \
  gcc \
  mediainfo \
  unzip \
  sqlite \
  libcurl && \
 echo "**** Dowload and build mono ****" && \
 git clone https://github.com/mono/mono.git /tmp/mono && \
 cd /tmp/mono && \
 sed -i 's|$mono_libdir/||g' \
  data/config.in && \
 sed -i '/exec "/ i\paxmark mr "$(readlink -f "$MONO_EXECUTABLE")"' \
  runtime/mono-wrapper.in && \
 ./autogen.sh \
  --prefix=/usr \
  --sysconfdir=/etc \
  --mandir=/usr/share/man \
  --infodir=/usr/share/info \
  --localstatedir=/var \
  --disable-rpath \
  --disable-boehm \
  --enable-parallel-mark \
  --with-mcs-docs=no \
  --without-sigaltstack && \
 make > /dev/null && \
 make install > /dev/null && \
 echo "**** Cleanup ****" && \
 apk del --purge \
 build-dependencies && \
 rm -rf \
  /usr/lib/*.la \
  /tmp/* \
  /root/.cache \
  /usr/lib/mono/*/Mono.Security.Win32* \
  /usr/lib/libMonoSupportW.*
