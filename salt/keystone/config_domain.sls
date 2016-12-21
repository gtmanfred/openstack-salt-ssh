{%- set output = salt['cmd.shell']('openstack domain show default --column id --format json --os-token adminpass --os-url http://controller:35357/v3 --os-identity-api-version 3')|load_json %}

default_domain_id:
  file.append:
    - name: /etc/keystone/keystone.conf
    - text: |
        [identity]
        default_domain_id = {{output[0]['Value']}}
