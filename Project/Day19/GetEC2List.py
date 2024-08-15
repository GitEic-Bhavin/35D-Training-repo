#!/usr/bin/env python3

import json
import boto3

def get_inventory():
    aws_access_key_id = 'Aws_access_key_value'
    aws_secret_access_key = 'Aws_Secret_key_value'
    region_name = 'us-east-2'
    
    ec2 = boto3.client(
        'ec2',
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        region_name=region_name
    )
    
    # ec2 = boto3.client('ec2', region_name='us-east-2')
    response = ec2.describe_instances(Filters=[{'Name': 'tag:Role', 'Values': ['webserver']}, {'Name': 'tag:Name', 'Values': ['Bhavin']}]) #{'Name': 'instanceType', 'Values': ['t2.micro', 't3.micro']}]) #, {'Name': 'tag:Name', 'Values': ['Bhavin']}])
    
    inventory = {
        'webserver2': {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }
    
    ssh_key_file = '/Path/to/Private_key_file.pem'
    ssh_user = 'ubuntu'
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            public_dns = instance.get('PublicDnsName', instance['InstanceId'])
            inventory['webserver2']['hosts'].append(public_dns)
            inventory['_meta']['hostvars'][public_dns] = {
                'ansible_host': instance.get('PublicIpAddress', instance['InstanceId']),
                'ansible_ssh_private_key_file': ssh_key_file,
                'ansible_user': ssh_user
            }
    
    return inventory

if __name__== '__main__':
    print(json.dumps(get_inventory()))
    