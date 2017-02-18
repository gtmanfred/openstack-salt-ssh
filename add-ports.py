from __future__ import print_function
from collections import namedtuple
import json
import os
import pprint
import requests
import sys
import time


endpoint = 'https://iad.networks.api.rackspacecloud.com/v2.0/'
token = os.environ.get('TOKEN')
pubnet = '00000000-0000-0000-0000-000000000000'

if not token:
    print('Token not set')
    sys.exit(1)

s = requests.Session()
s.headers['X-Auth-Token'] = token

management = {}
networks = s.get(endpoint + 'networks').json()['networks']
for network in networks:
    if network['name'] == 'management':
        management = network
        break

if not management:
    management= s.post(endpoint + 'networks', data=json.dumps({"network": {"name": "management"}})).json()['network']

network_id = management['id']

subnet = {}
subnets = s.get(endpoint + 'networks/%s' % network_id).json()['network']['subnets']
for subnet_id in subnets:
    this = s.get(endpoint + 'subnets/%s' % subnet_id).json()
    this = this['subnet']
    if this['cidr'] == '10.0.0.0/24' and this['name'] == 'management':
        subnet = this
        break

if not subnet:
    subnet = s.post(endpoint + 'subnets', data=json.dumps({"subnet":{"name":"management","cidr":"10.0.0.0/24","ip_version":4, "network_id": network_id}})).json()['subnet']

subnet_id = subnet['id']

onmetal = 'onmetal-general2-small'
virtual = 'general1-8'

om_image = '3f7a22c2-1b19-4d62-ace7-3ecea2e32134'
v_image = 'f2db6fd7-1e40-41f1-9ac0-ad8d1dfd7651'

ports = [
    ('salt', '10.0.0.2', virtual, v_image),
    ('controller', '10.0.0.11', virtual, v_image),
    #('compute01', '10.0.0.31', onmetal, om_image),
    #('compute02', '10.0.0.32', onmetal, om_image),
    ('compute01', '10.0.0.31', virtual, v_image),
    ('compute02', '10.0.0.32', virtual, v_image),
    ('block01', '10.0.0.41', virtual, v_image),
    ('block02', '10.0.0.42', virtual, v_image),
    ('object01', '10.0.0.51', virtual, v_image),
    ('object02', '10.0.0.52', virtual, v_image),
    ('object03', '10.0.0.53', virtual, v_image)
]

VM = namedtuple('VM', 'name, ip, flavor, image')

def make_port(vm_):
    return {
	"port": {
	    "admin_state_up": True,
	    "device_id": "",
	    "name": vm_.name,
	    "fixed_ips": [
		{
		    "ip_address": vm_.ip,
		    "subnet_id": subnet_id,
		}
	    ],
	    "network_id": network_id,
	}
    }

print('export PUBNET=%s' % pubnet)

for vm in map(VM._make, ports):
    while True:
        port = s.post(endpoint + 'ports', json.dumps(make_port(vm))).json()
        if 'overLimit' in port:
            time.sleep(10)
            continue
        if 'port' in port:
            break
        print(port)
    port = port['port']
    print('supernova brew-IAD boot --image %s --flavor %s --key-name gtmanfred --nic net-id=$PUBNET --nic port-id=%s %s' % (vm.image, vm.flavor, port['id'], vm.name))
    time.sleep(10)
