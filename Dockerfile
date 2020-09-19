FROM opensuse/leap:latest
LABEL maintainer="Radek Sprta <mail@radeksprta.eu>"

ENV pip_packages "ansible cryptography"

# Install dependencies.
RUN zypper install -y \
       sudo systemd systemd-sysvinit \
       wget libffi-devel libopenssl-devel \
       python3-pip python3-devel python3-setuptools python3-wheel \
    && zypper clean --all \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man

# Install Ansible via pip.
RUN pip3 install $pip_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /usr/lib/systemd/system/systemd*udev* \
    && rm -f /usr/lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
