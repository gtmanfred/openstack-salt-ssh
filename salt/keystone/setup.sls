check admin setup:
  cmd.run:
    - name: openstack token issue
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - onfail_in:
      - cmd: domain
      - cmd: project
      - cmd: user
      - cmd: role
      - cmd: user_role
      - cmd: service
      - cmd: endpoint

domain:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack domain create --description "Default Domain" default

project:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack project create --domain default --description "Admin Project" admin
      - openstack project create --domain default --description "Service Project" service
      - openstack project create --domain default --description "Demo Project" demo

user:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack user create --domain default --password adminpass admin
      - openstack user create --domain default --password demopass demo
      - openstack user create --domain default --password glancepass glance
      - openstack user create --domain default --password novapass nova
      - openstack user create --domain default --password neutronpass neutron

role:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack role create admin
      - openstack role create user

user_role:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack role add --project admin --user admin admin
      - openstack role add --project demo --user demo user
      - openstack role add --project service --user glance admin
      - openstack role add --project service --user nova admin
      - openstack role add --project service --user neutron admin

service:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack service create --name keystone --description "OpenStack Identity" identity
      - openstack service create --name glance --description "OpenStack Image" image
      - openstack service create --name nova --description "OpenStack Compute" compute
      - openstack service create --name neutron --description "OpenStack Networking" network

endpoint:
  cmd.run:
    - env:
      - OS_TOKEN: adminpass
      - OS_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - names:
      - openstack endpoint create --region RegionOne identity public http://controller:5000/v3
      - openstack endpoint create --region RegionOne identity internal http://controller:5000/v3
      - openstack endpoint create --region RegionOne identity admin http://controller:5000/v3
      - openstack endpoint create --region RegionOne image public http://controller:9292
      - openstack endpoint create --region RegionOne image internal http://controller:9292
      - openstack endpoint create --region RegionOne image admin http://controller:9292
      - openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1/%\(tenant_id\)s
      - openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1/%\(tenant_id\)s
      - openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1/%\(tenant_id\)s
      - openstack endpoint create --region RegionOne network public http://controller:9696
      - openstack endpoint create --region RegionOne network internal http://controller:9696
      - openstack endpoint create --region RegionOne network admin http://controller:9696

openrc files:
  file.managed:
    - names:
      - /root/admin-openrc:
        - contents: |
            export OS_PROJECT_DOMAIN_NAME=default
            export OS_USER_DOMAIN_NAME=default
            export OS_PROJECT_NAME=admin
            export OS_USERNAME=admin
            export OS_PASSWORD=adminpass
            export OS_AUTH_URL=http://controller:35357/v3
            export OS_IDENTITY_API_VERSION=3
            export OS_IMAGE_API_VERSION=2
      - /root/demo-openrc:
        - contents: |
            export OS_PROJECT_DOMAIN_NAME=default
            export OS_USER_DOMAIN_NAME=default
            export OS_PROJECT_NAME=demo
            export OS_USERNAME=demo
            export OS_PASSWORD=demopass
            export OS_AUTH_URL=http://controller:35357/v3
            export OS_IDENTITY_API_VERSION=3
            export OS_IMAGE_API_VERSION=2
      - /root/this:
        - contents: |
            . ~/admin-openrc
            neutron net-create --shared --provider:physical_network provider \
              --provider:network_type flat provider
            neutron subnet-create --name provider \
              --allocation-pool start=10.0.0.150,end=10.0.0.250 \
              --dns-nameserver 8.8.8.8 --gateway 10.0.0.129 \
              provider 10.0.0.128/25
            neutron net-update provider --router:external
            . ~/demo-openrc
            neutron net-create selfservice
            neutron subnet-create --name selfservice \
              --dns-nameserver 8.8.4.4 --gateway 172.16.1.1 \
              selfservice 172.16.1.0/24
            neutron router-create router
            neutron router-interface-add router selfservice
            neutron router-gateway-set router provider
      - /root/that:
        - contents: |
            . ~/demo-openrc
            neutron router-gateway-clear router
            neutron router-interface-delete router selfservice
            neutron router-delete router
            neutron net-delete selfservice
            . ~/admin-openrc
            neutron net-delete provider
