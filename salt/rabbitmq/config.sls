openstack:
  rabbitmq_user.present:
    - password: rabbitpass
    - perms:
      - '/':
        - '.*'
        - '.*'
        - '.*'
