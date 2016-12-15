/etc/keystone/keystone.conf:
  file.managed:
    - contents: |
        [database]
        connection = mysql+pymysql://keystone:keystonepass@controller/keystone
        [token]
        provider = fernet

populate keystone db:
  cmd.run:
    - name: keystone-manage db_sync
    - runas: keystone

setup keystone db:
  cmd.run:
    - names:
      - keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
      - keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

httpd_servername:
  file.managed:
    - name: /etc/httpd/conf.d/openstack.conf
    - contents: |
        ServerName controller

httpd_wsgi:
  file.symlink:
    - name: /etc/httpd/conf.d/wsgi-keystone.conf
    - target: /usr/share/keystone/wsgi-keystone.conf
