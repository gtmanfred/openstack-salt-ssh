start nova services:
  service.running:
    - names:
      - openstack-nova-api.service
      - openstack-nova-consoleauth.service
      - openstack-nova-scheduler.service
      - openstack-nova-conductor.service
      - openstack-nova-novncproxy.service
    - enable: true
