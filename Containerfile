ARG COREOS_VERSION="${COREOS_VERSION:-stable}"

FROM ghcr.io/ublue-os/ucore:${COREOS_VERSION}


ARG COREOS_VERSION="${COREOS_VERSION:-stable}"

COPY build.sh /tmp/build.sh
COPY usr /usr

# enable testing repos if not enabled on testing stream
RUN if [[ "testing" == "${COREOS_VERSION}" ]]; then \
for REPO in $(ls /etc/yum.repos.d/fedora-updates-testing{,-modular}.repo); do \
  if [[ "$(grep enabled=1 ${REPO} > /dev/null; echo $?)" == "1" ]]; then \
    echo "enabling $REPO" &&\
    sed -i '0,/enabled=0/{s/enabled=0/enabled=1/}' ${REPO}; \
  fi; \
done; \
fi

# disable archive, openh265 and modular repos
RUN sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo

# install packages
RUN mkdir -p /var/lib/alternatives \
    && /tmp/build.sh \
    && mv /var/lib/alternatives /staged-alternatives \
    && rm -fr /tmp/* /var/* \
    && rpm-ostree cleanup -m \
    && ostree container commit \
    && mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives \
    && mkdir -p /tmp /var/tmp \
    && chmod -R 1777 /tmp /var/tmp