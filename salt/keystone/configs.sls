/etc/keystone/keystone.conf:
  file.managed:
    - contents: |
        [DEFAULT]
        admin_token = adminpass
        [database]
        connection = mysql+pymysql://keystone:keystonepass@controller/keystone
        [token]
        provider = fernet
        {%- if salt.service.get_running('httpd') %}
        {%- set output = salt['cmd.shell']('openstack domain show default --column id --format json --os-token adminpass --os-url http://controller:35357/v3 --os-identity-api-version 3')|load_json %}
        [identity]
        default_domain_id = {{output[0]['Value']}}
        {%- endif %}

populate keystone db:
  cmd.run:
    - name: keystone-manage db_sync
    - runas: keystone

setup keystone db:
  cmd.run:
    - name: keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

keystone config:
  file.managed:
    - names:
      - /etc/httpd/conf.d/openstack.conf:
        - contents: |
            ServerName controller
      - /etc/httpd/conf.d/wsgi-keystone.conf:
        - contents: |
            Listen 5000
            Listen 35357

            <VirtualHost *:5000>
                WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
                WSGIProcessGroup keystone-public
                WSGIScriptAlias / /usr/bin/keystone-wsgi-public
                WSGIApplicationGroup %{GLOBAL}
                WSGIPassAuthorization On
                ErrorLogFormat "%{cu}t %M"
                ErrorLog /var/log/httpd/keystone-error.log
                CustomLog /var/log/httpd/keystone-access.log combined

                <Directory /usr/bin>
                    Require all granted
                </Directory>
            </VirtualHost>

            <VirtualHost *:35357>
                WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
                WSGIProcessGroup keystone-admin
                WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
                WSGIApplicationGroup %{GLOBAL}
                WSGIPassAuthorization On
                ErrorLogFormat "%{cu}t %M"
                ErrorLog /var/log/httpd/keystone-error.log
                CustomLog /var/log/httpd/keystone-access.log combined

                <Directory /usr/bin>
                    Require all granted
                </Directory>
            </VirtualHost>
