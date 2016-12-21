httpd:
  service.running: 
    - enable: true
    - listen:
      - file: /etc/keystone/keystone.conf
      - file: default_domain_id
