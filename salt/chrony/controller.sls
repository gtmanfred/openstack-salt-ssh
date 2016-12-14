include:
  - .pkg

/etc/chrony.conf:
  file.managed:
    - source: salt://chrony/files/controller.conf
  service.running:
    - name: chronyd
    - enable: true
    - listen:
      - file: /etc/chrony.conf
