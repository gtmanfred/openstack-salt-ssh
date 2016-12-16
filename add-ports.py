import json
import os
import pprint
import requests
import sys
import time


endpoint = 'https://iad.networks.api.rackspacecloud.com/v2.0/'
IMAGE='dc1a3708-b4d9-44db-98ae-f768f6218f27'
token = os.environ.get('TOKEN')
pubnet='00000000-0000-0000-0000-000000000000'

if not token:
    print 'Token not set'
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

ports = [
    ('salt', '10.0.0.2'),
    ('controller', '10.0.0.11'),
    ('compute01', '10.0.0.31'),
    ('compute02', '10.0.0.32'),
    ('block01', '10.0.0.41'),
    ('block02', '10.0.0.42'),
    ('object01', '10.0.0.51'),
    ('object02', '10.0.0.52'),
    ('object03', '10.0.0.53')
]

def make_port(name, ip_):
    return {
	"port": {
	    "admin_state_up": True,
	    "device_id": "",
	    "name": name,
	    "fixed_ips": [
		{
		    "ip_address": ip_,
		    "subnet_id": subnet_id,
		}
	    ],
	    "network_id": network_id,
	}
    }

for name, ip_ in ports:
    while True:
        port = s.post(endpoint + 'ports', json.dumps(make_port(name, ip_))).json()
        if 'overLimit' in port:
            time.sleep(10)
            continue
        if 'port' in port:
            break
        print port
    port = port['port']
    print 'supernova brew-IAD boot --image %s --flavor general1-8 --key-name gtmanfred --nic port-id=%s --nic net-id=%s %s' % (IMAGE, port['id'], pubnet, port['name'])
    time.sleep(10)
