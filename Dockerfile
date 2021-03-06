ARG VERSION=15
FROM opensuse/leap:$VERSION

LABEL maintainer="Radek Sprta <mail@radeksprta.eu>"
LABEL org.opencontainers.image.authors="Radek Sprta <mail@radeksprta.eu>"
LABEL org.opencontainers.image.description="OpenSuse container for Ansible playbook and role testing in Molecule."
LABEL org.opencontainers.image.documentation="https://radek-sprta.gitlab.io/docker-opensuse-ansible"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.source="https://gitlab.com/radek-sprta/docker-opensuse-ansible"
LABEL org.opencontainers.image.title="rsprta/opensuse-ansible"
LABEL org.opencontainers.image.url="https://gitlab.com/radek-sprta/docker-opensuse-ansible"

ENV pip_packages "ansible cryptography"

# Install Ansible and dependencies.
RUN zypper install -y \
       cargo \
       gcc \
       gzip \
       libffi-devel \
       libopenssl-devel \
       python3-devel \
       python3-pip \
       python3-setuptools \
       python3-wheel \
       sudo \
       systemd \
       systemd-sysvinit \
       tar \
       wget \
    && pip3 install --upgrade pip \
    && pip3 install $pip_packages \
    && zypper remove -y \
       cargo \
       gcc \
       libffi-devel \
       libopenssl-devel \
       python3-devel \
       python3-pip \
       python3-setuptools \
       python3-wheel \
    && zypper clean --all \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /usr/lib/systemd/system/systemd*udev* \
    && rm -f /usr/lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
