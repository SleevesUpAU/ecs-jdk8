#!/usr/bin/env python

from __future__ import print_function
import os
import subprocess

os.environ["VAULT_ADDR"] = "http://" + (os.environ["CONSUL_URL"]) + ":8200/"
print (os.environ["VAULT_ADDR"])
os.system('vault login -method=aws role=' + (os.environ["IAM_ROLE"]))

newrelic_license_key = 'vault kv get -field=newrelic_license_key secret/tenancy-service/new-relic'
app_name = 'vault kv get -field=app_name secret/tenancy-service/new-relic'
env = 'vault kv get -field=env secret/tenancy-service/new-relic'

def transform_newrelic_conf():
    with open('/newrelic.yml', 'r') as f:
        template = f.read()

    content = (
        template.replace('___NEW_RELIC_LICENSE_KEY___', subprocess.Popen(newrelic_license_key.split(" "), stdout=subprocess.PIPE).stdout.readline())                
            .replace('___ENVIRONMENT_NAME___', '{}'.format(subprocess.Popen(env.split(" "), stdout=subprocess.PIPE).stdout.readline()))
            .replace('___APPLICATION_NAME___', '{}'.format(subprocess.Popen(app_name.split(" "), stdout=subprocess.PIPE).stdout.readline()))
            .replace('log_level: info', 'log_level: off')
            )

    with open('/newrelic.yml', 'w') as f:
        f.write(str(content))

def main():
    transform_newrelic_conf()

if __name__ == '__main__':
    main()