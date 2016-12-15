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
    - glance
  'compute*':
    - chrony.other
  'block*':
    - chrony.other
  'object*':
    - chrony.other
