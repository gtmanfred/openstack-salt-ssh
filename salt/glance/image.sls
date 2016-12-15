check image:
  cmd.run:
    - name: openstack image show cirros

get image:
  cmd.run:
    - name: wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
    - onfail:
      - cmd: check image

upload image:
  cmd.run:
    - name: openstack image create "cirros" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public
    - env:
      - OS_USERNAME: admin
      - OS_PASSWORD: adminpass
      - OS_PROJECT_NAME: admin
      - OS_USER_DOMAIN_NAME: default
      - OS_PROJECT_DOMAIN_NAME: default
      - OS_AUTH_URL: http://controller:35357/v3
      - OS_IDENTITY_API_VERSION: '3'
    - onfail:
      - cmd: check image
