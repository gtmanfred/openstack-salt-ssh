rabbit_user:
  rabbitmq_user.present:
    - password: rabbitpass
    - perms:
      - 'openstack':
        - '.*'
        - '.*'
        - '.*'
