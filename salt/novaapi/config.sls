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

        [api_database]
        connection = mysql+pymysql://nova:novapass@controller/nova_api

        [database]
        connection = mysql+pymysql://nova:novapass@controller/nova

        [vnc]
        vncserver_listen = $my_ip
        vncserver_proxyclient_address = $my_ip

        [serial_console]
        enabled=true

        [glance]
        api_servers = http://controller:9292

        [oslo_concurrency]
        lock_path = /var/lib/nova/tmp

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
        service_metadata_proxy = True
        metadata_proxy_shared_secret = secret

neutron configs:
  file.managed:
    - names:
      - /etc/neutron/neutron.conf:
        - contents: |
            [database]
            connection = mysql+pymysql://neutron:neutronpass@controller/neutron

            [DEFAULT]
            core_plugin = ml2
            service_plugins = router
            allow_overlapping_ips = True
            transport_url = rabbit://openstack:rabbitpass@controller
            auth_strategy = keystone
            notify_nova_on_port_status_changes = True
            notify_nova_on_port_data_changes = True

            [nova]
            auth_url = http://controller:35357
            auth_type = password
            project_domain_name = default
            user_domain_name = default
            region_name = RegionOne
            project_name = service
            username = nova
            password = novapass

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

      - /etc/neutron/plugins/ml2/ml2_conf.ini:
        - contents: |
            [ml2]
            type_drivers = flat,vlan,vxlan
            tenant_network_types = vxlan
            mechanism_drivers = linuxbridge,l2population
            extension_drivers = port_security

            [ml2_type_flat]
            flat_networks = provider

            [ml2_type_vxlan]
            vni_ranges = 1:1000

            [securitygroup]
            enable_ipset = True

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

      - /etc/neutron/l3_agent.ini:
        - contents: |
            [DEFAULT]
            interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver

      - /etc/neutron/dhcp_agent.ini:
        - contents: |
            [DEFAULT]
            interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
            dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
            enable_isolated_metadata = True
            dnsmasq_config_file = /etc/neutron/dnsmasq-neutron.conf

      - /etc/neutron/dnsmasq-neutron.conf:
        - contents: |
            dhcp-option-force=26,1400

      - /etc/neutron/metadata_agent.ini:
        - contents: |
            [DEFAULT]
            nova_metadata_ip = controller
            metadata_proxy_shared_secret = secret

ml2 config symlink:
  file.symlink:
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini
    - name: /etc/neutron/plugin.ini
