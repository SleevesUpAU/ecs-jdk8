#!/usr/bin/env python

from __future__ import print_function
import os
import subprocess

os.environ["VAULT_ADDR"] = "http://" + (os.environ["CONSUL_URL"]) + ":8200/"
print (os.environ["VAULT_ADDR"])
os.system('vault login -method=aws role=' + (os.environ["IAM_ROLE"]))

newrelic_license_key = 'vault kv get -field=newrelic_license_key secret/new-relic'
env = os.environ["ENVIRONMENT"]
app_name = os.environ["CONTAINER_NAME"]

def transform_newrelic_conf():
    with open('/newrelic.yml', 'r') as f:
        template = f.read()

    content = (
        template.replace('__LICENSE_KEY__', subprocess.Popen(newrelic_license_key.split(" "), stdout=subprocess.PIPE).stdout.readline())              
            .replace('__ENVIRONMENT_NAME__', env)
            .replace('__NEWRELIC_NAME__', app_name)
            .replace('log_level: info', 'log_level: off')
            )

    with open('/newrelic.yml', 'w') as f:
        f.write(content)

def main():
    transform_newrelic_conf()

if __name__ == '__main__':
    main()
