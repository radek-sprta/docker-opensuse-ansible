# OpenSuse Ansible

## Quick reference
-	**Maintained by**: [Radek Sprta](https://gitlab.com/radek-sprta)
-	**Where to get help**: [Repository Issues](https://gitlab.com/radek-sprta/docker-opensuse-ansible/-/issues)

## Description
OpenSuse container for Ansible playbook and role testing in Molecule.

## Usage
The simplest way to run the container is the following command:

```bash
docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro rsprta/opensuse-ansible:latest` 
```

Or in `molecule.yml`:

```yaml
platforms:
  - name: instance
    image: docker.io/rsprta/opensuse-ansible
    command: ''
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    privileged: true
    pre_build_image: true
```

## Contact
[mail@radeksprta.eu](mailto:mail@radeksprta.eu)  
[incoming+radek-sprta/docker-opensuse-ansible@gitlab.com](incoming+radek-sprta/docker-opensuse-ansible@gitlab.com)

## License
GNU General Public License v3

## Credits
The container is based on work by [Jeff Geerling](https://hub.docker.com/u/geerlingguy)
