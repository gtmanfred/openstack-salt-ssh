base:
  '*':
    - repos
    - hosts
    - firewalld
    - openstack.pkgs
  'controller':
    - chrony.controller
    - sysctl
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
