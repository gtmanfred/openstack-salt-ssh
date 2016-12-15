glance services:
  service.running:
    - names:
      - openstack-glance-api.service
      - openstack-glance-registry.service
    - enable: true
