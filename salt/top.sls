base:
  '*':
    - hosts
  'controller':
    - chrony.controller
    - mysql
  'compute*':
    - chrony.other
  'block*':
    - chrony.other
  'object*':
    - chrony.other
