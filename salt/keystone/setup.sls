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

bootstrap:
  cmd.run:
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - name: keystone-manage bootstrap --bootstrap-password adminpass --bootstrap-admin-url http://controller:35357/v3/ --bootstrap-internal-url http://controller:35357/v3/ --bootstrap-public-url http://controller:5000/v3/ --bootstrap-region-id RegionOne
    - onfail:
      - cmd: check admin setup

service_project:
  cmd.run:
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - name: openstack project create --domain default --description "Service Project" service
    - onfail:
      - cmd: check admin setup

demo_project:
  cmd.run:
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - name: openstack project create --domain default --description "Demo Project" demo
    - onfail:
      - cmd: check admin setup

demo_user:
  cmd.run:
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - name: openstack user create --domain default --password demopass demo
    - onfail:
      - cmd: check admin setup

user_role:
  cmd.run:
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - name: openstack role create user
    - onfail:
      - cmd: check admin setup

demo_user_role:
  cmd.run:
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - name: openstack role add --project demo --user demo user
    - onfail:
      - cmd: check admin setup

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
