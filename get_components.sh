mkdir -p rootfs/tmp/bitnami/pkg/cache && cd rootfs/tmp/bitnami/pkg/cache && \
    COMPONENTS=( \
      "python-3.8.16-0-linux-amd64-debian-11" \
      "wait-for-port-1.0.5-1-linux-amd64-debian-11" \
      "ruby-2.7.6-0-linux-amd64-debian-11" \
      "postgresql-client-15.1.0-0-linux-amd64-debian-11" \
      "node-14.21.2-0-linux-amd64-debian-11" \
      "brotli-1.0.9-154-linux-amd64-debian-11" \
      "gosu-1.16.0-0-linux-amd64-debian-11" \
      "discourse-2.8.13-0-linux-amd64-debian-11" \
      "postgresql-15.1.0-3-linux-amd64-debian-11" \
      "redis-7.0.7-0-linux-amd64-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ;
    done
