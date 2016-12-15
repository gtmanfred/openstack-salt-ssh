start nova services:
  service.running:
    - names:
      - openstack-nova-api.service
      - openstack-nova-consoleauth.service
      - openstack-nova-scheduler.service
      - openstack-nova-conductor.service
      - openstack-nova-novncproxy.service
      - neutron-server.service
      - neutron-linuxbridge-agent.service
      - neutron-dhcp-agent.service
      - neutron-metadata-agent.service
      - neutron-l3-agent.service
    - enable: true
