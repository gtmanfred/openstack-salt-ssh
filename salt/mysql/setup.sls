database:
  mysql_database.present:
    - names:
      - keystone
      - glance
      - nova_api
      - nova
      - neutron
    - connection_host: 10.0.0.11

user_localhost:
  mysql_user.present:
    - names:
      - keystone:
        - password: keystonepass
      - glance:
        - password: glancepass
      - nova:
        - password: novapass
      - neutron:
        - password: neutronpass
    - host: localhost
    - connection_host: 10.0.0.11

user_me:
  mysql_user.present:
    - names:
      - keystone:
        - password: keystonepass
      - glance:
        - password: glancepass
      - nova:
        - password: novapass
      - neutron:
        - password: neutronpass
    - host: '10.0.0.11'
    - connection_host: 10.0.0.11

user_all:
  mysql_user.present:
    - names:
      - keystone:
        - password: keystonepass
      - glance:
        - password: glancepass
      - nova:
        - password: novapass
      - neutron:
        - password: neutronpass
    - host: '10.0.0.%'
    - connection_host: 10.0.0.11

grants:
  mysql_grants.present:
    - names:
      - keystone_localhost:
        - user: keystone
        - host: localhost
        - database: keystone.*
      - keystone_me:
        - user: keystone
        - host: '10.0.0.11'
        - database: keystone.*
      - keystone_all:
        - user: keystone
        - host: '10.0.0.%'
        - database: keystone.*
      - glance_localhost:
        - user: glance
        - host: localhost
        - database: glance.*
      - glance_me:
        - user: glance
        - host: '10.0.0.11'
        - database: glance.*
      - glance_all:
        - user: glance
        - host: '10.0.0.%'
        - database: glance.*
      - nova_localhost:
        - user: nova
        - host: localhost
        - database: nova.*
      - nova_me:
        - user: nova
        - host: '10.0.0.11'
        - database: nova.*
      - nova_all:
        - user: nova
        - host: '10.0.0.%'
        - database: nova.*
      - neutron_localhost:
        - user: neutron
        - host: localhost
        - database: neutron.*
      - neutron_me:
        - user: neutron
        - host: '10.0.0.11'
        - database: neutron.*
      - neutron_all:
        - user: neutron
        - host: '10.0.0.%'
        - database: neutron.*
    - grant: all privileges
    - connection_host: 10.0.0.11
