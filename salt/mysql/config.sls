/etc/my.cnf.d/openstack.cnf:
  file.managed:
    - source: salt://mysql/files/openstack.cnf
