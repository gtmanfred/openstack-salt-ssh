setup glance db:
  cmd.run:
    - name: glance-manage db_sync
    - runas: glance
