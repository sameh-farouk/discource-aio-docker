FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH
# args for postgrs
ARG EXTRA_LOCALES
ARG WITH_ALL_LOCALES="no"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file gifsicle git hostname imagemagick jhead jpegoptim libbrotli1 libbsd0 libbz2-1.0 libcom-err2 libcrypt1 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpq5 libreadline-dev libreadline8 libsasl2-2 libsqlite3-0 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libxml2 libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 zlib1g liblz4-1 libncurses6 libpcre3 libzstd1 locales wget openssh-server ufw libz-dev

COPY rootfs /
RUN mkdir -p /tmp/bitnami/pkg/cache && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "python-3.8.16-0-linux-${OS_ARCH}-debian-11" \
      "wait-for-port-1.0.5-1-linux-${OS_ARCH}-debian-11" \
      "ruby-2.7.6-0-linux-${OS_ARCH}-debian-11" \
      "postgresql-client-15.1.0-0-linux-${OS_ARCH}-debian-11" \
      "node-14.21.2-0-linux-${OS_ARCH}-debian-11" \
      "brotli-1.0.9-154-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
      "discourse-2.8.13-0-linux-${OS_ARCH}-debian-11" \
      "postgresql-15.1.0-3-linux-${OS_ARCH}-debian-11" \
      "redis-7.0.7-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
      fi && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz ; \
    done

RUN wget -nv -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.9/zinit

RUN apt-get autoremove --purge -y curl wget && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN chmod g+rwX /opt/bitnami

# postgres
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN /opt/bitnami/scripts/postgresql/postunpack.sh
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh

# redis
RUN ln -s /opt/bitnami/scripts/redis/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/redis/run.sh /run.sh
RUN /opt/bitnami/scripts/redis/postunpack.sh

#discourse
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'
RUN /opt/bitnami/scripts/discourse/postunpack.sh

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so" \
    APP_VERSION="2.8.13" \
    BITNAMI_APP_NAME="discourse" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/brotli/bin:/opt/bitnami/redis/bin:$PATH"

EXPOSE 3000 5432 6379
COPY zinit /
RUN chmod +x /sbin/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
