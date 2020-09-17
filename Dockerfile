FROM opensuse/leap:latest
LABEL maintainer="Radek Sprta <mail@radeksprta.eu>"

ENV DEBIAN_FRONTEND noninteractive
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

COPY initctl_faker .
RUN chmod +x initctl_faker \
    && rm -rf /sbin/initctl \
    && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd doesn't start agettys on tty[1-6].
RUN rm -f /usr/lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
