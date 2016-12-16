private nat gateway:
  network.managed:
    - name: eth1:1
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 10.0.0.129
    - netmask: 255.255.255.128
