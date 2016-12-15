setup nova database:
  cmd.run:
    - runas: nova
    - names:
      - nova-manage api_db sync
      - nova-manage db sync

setup neutron database:
  cmd.run:
    - runas: neutron
    - name: neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head
