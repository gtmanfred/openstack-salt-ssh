glance config files:
  file.managed:
    - names:
      - /etc/glance/glance-api.conf:
        - contents: |
            [database]
            connection = mysql+pymysql://glance:glancepass@controller/glance

            [keystone_authtoken]
            auth_uri = http://controller:5000
            auth_url = http://controller:35357
            memcached_servers = controller:11211
            auth_type = password
            project_domain_name = default
            user_domain_name = default
            project_name = service
            username = glance
            password = glancepass

            [paste_deploy]
            flavor = keystone

            [glance_store]
            stores = file,http
            default_store = file
            filesystem_store_datadir = /var/lib/glance/images/

      - /etc/glance/glance-registry.conf:
        - contents: |
            [database]
            connection = mysql+pymysql://glance:glancepass@controller/glance

            [keystone_authtoken]
            auth_uri = http://controller:5000
            auth_url = http://controller:35357
            memcached_servers = controller:11211
            auth_type = password
            project_domain_name = default
            user_domain_name = default
            project_name = service
            username = glance
            password = glancepass

            [paste_deploy]
            flavor = keystone
