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
  'block*':
    - chrony.other
  'object*':
    - chrony.other
