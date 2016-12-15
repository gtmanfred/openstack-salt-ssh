libvirtd service:
  service.running:
    - name: libvirtd

openstack-nova-compute service:
  service.running:
    - name: openstack-nova-compute
    - onlyif: sleep 5
