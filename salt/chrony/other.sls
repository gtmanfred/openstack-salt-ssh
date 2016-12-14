include:
  - .pkg

/etc/chrony.conf:
  file.managed:
    - source: salt://chrony/files/other.conf
  service.running:
    - name: chronyd
    - enable: true
    - listen:
      - file: /etc/chrony.conf
