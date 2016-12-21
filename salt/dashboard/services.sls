restart services:
  service.running:
    - names:
      - httpd
      - memcached
    - listen:
      - file: /etc/openstack-dashboard/local_settings
