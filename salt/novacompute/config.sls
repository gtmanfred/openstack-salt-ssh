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
