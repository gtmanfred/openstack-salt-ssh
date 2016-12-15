keystone_database:
  mysql_database.present:
    - name: keystone
    - connection_host: 10.0.0.11

keystone_user_localhost:
  mysql_user.present:
    - name: keystone
    - host: localhost
    - password: keystonepass
    - connection_host: 10.0.0.11

keystone_user_me:
  mysql_user.present:
    - name: keystone
    - host: '10.0.0.11'
    - password: keystonepass
    - connection_host: 10.0.0.11

keystone_user_all:
  mysql_user.present:
    - name: keystone
    - host: '10.0.0.%'
    - password: keystonepass
    - connection_host: 10.0.0.11

keystone_grants:
  mysql_grants.present:
    - names:
      - keystone_localhost:
        - user: keystone
        - host: localhost
      - keystone_me:
        - user: keystone
        - host: '10.0.0.11'
      - keystone_all:
        - user: keystone
        - host: '10.0.0.%'
    - database: keystone.*
    - grant: all privileges
    - connection_host: 10.0.0.11
