base:
  '*':
    - hosts
  'controller':
    - chrony.controller
    - openstack.pkgs
    - mysql
    - rabbitmq
  'compute*':
    - chrony.other
  'block*':
    - chrony.other
  'object*':
    - chrony.other
