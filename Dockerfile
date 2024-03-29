FROM python:2-slim-buster

# LDAP Exporter image for OpenShift Origin

LABEL io.k8s.description="LDAP Prometheus Exporter." \
      io.k8s.display-name="LDAP Exporter" \
      io.openshift.expose-services="9113:http" \
      io.openshift.tags="ldap,exporter,prometheus" \
      io.openshift.non-scalable="true" \
      help="For more information visit https://github.com/Worteks/docker-ldapexporter" \
      maintainer="Samuel MARTIN MORO <faust64@gmail.com>" \
      version="1.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/src/app /config
WORKDIR /usr/src/app
COPY config/* /usr/src/app/
RUN mv run-exporter.sh / \
    && apt-get update \
    && if test "$DO_UPGRADE"; then \
	echo "# Upgrade Base Image"; \
	apt-get -y upgrade; \
	apt-get -y dist-upgrade; \
    fi \
    && apt-get install -y gcc \
    && chown -R root:root /config \
    && chmod -R g=u /config \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get remove --purge -y gcc \
    && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
    && unset HTTP_PROXY HTTPS_PROXY NO_PROXY DO_UPGRADE http_proxy https_proxy

ENTRYPOINT [ "/run-exporter.sh" ]
USER 1001
