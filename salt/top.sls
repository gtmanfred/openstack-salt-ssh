base:
  '*':
    - hosts
  'controller':
    - chrony.controller
    - openstack.pkgs
    - mysql
  'compute*':
    - chrony.other
  'block*':
    - chrony.other
  'object*':
    - chrony.other
