setup nova database:
  cmd.run:
    - runas: nova
    - names:
      - nova-manage api_db sync
      - nova-manage db sync
