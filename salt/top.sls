base:
  '*':
    - hosts
  'controller':
    - chrony.controller
    - openstack.pkgs
    - mysql
    - rabbitmq
    - memcached
    - keystone
  'compute*':
    - chrony.other
  'block*':
    - chrony.other
  'object*':
    - chrony.other
