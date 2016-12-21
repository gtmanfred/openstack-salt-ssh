/etc/openstack-dashboard/local_settings:
  file.managed:
    - contents: |
        OPENSTACK_HOST = "controller"
        ALLOWED_HOSTS = ['*', ]
        SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

        CACHES = {
            'default': {
                'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
                'LOCATION': 'controller:11211',
            }
        }
        OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
        OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
        OPENSTACK_API_VERSIONS = {
            "identity": 3,
            "image": 2,
            "volume": 2,
        }
        OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "default"
        OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
        TIME_ZONE = "US/Chicago"
