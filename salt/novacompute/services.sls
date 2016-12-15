libvirtd service:
  service.running:
    - name: libvirtd

openstack-nova-compute service:
  service.running:
    - names:
      - openstack-nova-compute
      - neutron-linuxbridge-agent
    - onlyif: sleep 5
