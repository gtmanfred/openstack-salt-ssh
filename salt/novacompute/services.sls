libvirtd service:
  service.running:
    - name: libvirtd
    - enable: true

openstack-nova-compute service:
  service.running:
    - names:
      - openstack-nova-compute
      - neutron-linuxbridge-agent
    - enable: true
    - onlyif: sleep 5
