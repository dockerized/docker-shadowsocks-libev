#
# Dockerfile for shadowsocks-libev
#

FROM alpine:edge
MAINTAINER Tony.Shao <xiocode@gmail.com>
RUN set -ex \
    # Build environment setup
    && apk add --no-cache --virtual .build-deps \
                                git \
                                autoconf \
                                automake \
                                make \
                                build-base \
                                curl \
                                libev-dev \
                                libtool \
                                linux-headers \
                                udns-dev \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                c-ares-dev \
    # Build & install
    && cd /tmp/ \
    && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && cd shadowsocks-libev \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && cd /tmp/ \
    && git clone https://github.com/shadowsocks/simple-obfs.git shadowsocks-obfs \
    && cd shadowsocks-obfs \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install \
    && cd .. \
    && apk del .build-deps \
    && apk add --no-cache \
        rng-tools \
        $(scanelf --needed --nobanner /usr/bin/ss-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u) \
    && rm -rf /tmp/*

USER nobody

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_ADDR_IPV6 ::0
ENV SERVER_PORT 8388
ENV PASSWORD 1234567890
ENV METHOD chacha20
ENV TIMEOUT 3600
ENV DNS_ADDRS 1.1.1.1,1.0.0.1
ENV OBFS_OPTS obfs=http

CMD exec ss-server \
                -s $SERVER_ADDR \
                -d $DNS_ADDRS \               
                -p $SERVER_PORT \
                -k $PASSWORD \
                -m $METHOD \
                -t $TIMEOUT \
                --fast-open \
                -u \
                --no-delay \
                --reuse-port \
                --plugin obfs-server \
                --plugin-opts "${OBFS_OPTS}"
