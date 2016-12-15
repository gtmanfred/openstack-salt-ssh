base:
  '*':
    - hosts
    - firewalld
  'controller':
    - chrony.controller
    - openstack.pkgs
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
