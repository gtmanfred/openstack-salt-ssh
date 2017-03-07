update systems:
  salt.state:
    - tgt: '*'
    - sls: setup
    - ssh: True

wait for controller reboot:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
      - controller

setup controller:
  salt.state:
    - tgt: controller
    - highstate: True
    - ssh: True

setup compute:
  salt.state:
    - tgt: 'compute*'
    - highstate: True
    - ssh: True
