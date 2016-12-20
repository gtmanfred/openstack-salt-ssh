base:
  '*':
    - repos
    - hosts
    - firewalld
    - openstack.pkgs
    - sysctl
  'controller':
    - chrony.controller
    - mysql
    - rabbitmq
    - memcached
    - network
    - keystone
    - glance
    - novaapi
  'compute*':
    - chrony.other
    - novacompute
  'block*':
    - chrony.other
  'object*':
    - chrony.other
