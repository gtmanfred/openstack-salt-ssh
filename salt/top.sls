base:
  '*':
    - hosts
  'controller':
    - chrony.controller
  'compute*':
    - chrony.other
  'block*':
    - chrony.other
  'object*':
    - chrony.other
