import json
import os
import pprint
import requests
import sys
import time


endpoint = 'https://iad.networks.api.rackspacecloud.com/v2.0/'
IMAGE='4319b4ff-f887-4c52-9464-34536d202143'
token = os.environ.get('TOKEN')

if not token:
    print 'Token not set'
    sys.exit(1)

s = requests.Session()
s.headers['X-Auth-Token'] = token

ports = s.get(endpoint + 'ports').json()['ports']
for port in ports:
    network_id = port['network_id']
    s.delete(endpoint + 'ports/%s' % port['id'])
s.delete(endpoint + 'networks/%s' % network_id)
