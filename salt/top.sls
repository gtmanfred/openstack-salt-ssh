base:
  '*':
    - hosts
    - firewalld
    - openstack.pkgs
  'controller':
    - chrony.controller
    - mysql
    - rabbitmq
    - memcached
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
