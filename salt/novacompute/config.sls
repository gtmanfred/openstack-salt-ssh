/etc/nova/nova.conf:
  file.managed:
    - contents: |
        [DEFAULT]
        enabled_apis = osapi_compute,metadata
        transport_url = rabbit://openstack:rabbitpass@controller
        auth_strategy = keystone
        my_ip = 10.0.0.11
        use_neutron = True
        firewall_driver = nova.virt.firewall.NoopFirewallDriver

        [keystone_authtoken]
        auth_uri = http://controller:5000
        auth_url = http://controller:35357
        memcached_servers = controller:11211
        auth_type = password
        project_domain_name = default
        user_domain_name = default
        project_name = service
        username = nova
        password = novapass

        [vnc]
        enabled = True
        vncserver_listen = 0.0.0.0
        vncserver_proxyclient_address = $my_ip
        novncproxy_base_url = http://controller:6080/vnc_auto.html

        [serial_console]
        enabled = true

        [glance]
        api_servers = http://controller:9292

        [oslo_concurrency]
        lock_path = /var/lib/nova/tmp

        [libvirt]
        virt_type = qemu

        [neutron]
        url = http://controller:9696
        auth_url = http://controller:35357
        auth_type = password
        project_domain_name = default
        user_domain_name = default
        region_name = RegionOne
        project_name = service
        username = neutron
        password = neutronpass

neutron compute configs:
  file.managed:
    - names:
      - /etc/neutron/neutron.conf:
        - contents: |
            [DEFAULT]
            transport_url = rabbit://openstack:rabbitpass@controller
            auth_strategy = keystone

            [keystone_authtoken]
            auth_uri = http://controller:5000
            auth_url = http://controller:35357
            memcached_servers = controller:11211
            auth_type = password
            project_domain_name = default
            user_domain_name = default
            project_name = service
            username = neutron
            password = neutronpass

            [oslo_concurrency]
            lock_path = /var/lib/neutron/tmp

      - /etc/neutron/plugins/ml2/linuxbridge_agent.ini:
        - contents: |
            [linux_bridge]
            physical_interface_mappings = provider:eth1
            [vxlan]
            enable_vxlan = True
            local_ip = {{salt['network.ip_addrs'](cidr='10.0.0.0/24')[0]}}
            l2_population = True
            [agent]
            prevent_arp_spoofing = True
            [securitygroup]
            enable_security_group = True
            firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
