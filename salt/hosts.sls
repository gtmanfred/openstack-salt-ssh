/etc/hosts:
  file.managed:
    - contents: |
        127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
        ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
        10.0.0.11 controller
        10.0.0.31 compute01
        10.0.0.32 compute02
        10.0.0.41 block01
        10.0.0.42 block02
        10.0.0.51 object01
        10.0.0.52 object02
        10.0.0.53 object03
