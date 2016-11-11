#!/usr/bin/env python

import os
import boto3
import yaml

env_vars = {}

with open('/var/lib/cloud/instance/user-data.txt') as f:
  user_data = yaml.load(f)
  if user_data.has_key('environment'):
    for k, v in user_data['environment'].iteritems():
      env_vars[k.upper()]=v

if 'S3_CONFIG_BUCKET' in env_vars:
  try:
    s3 = boto3.resource('s3')
    object = s3.Object((env_vars['S3_CONFIG_BUCKET']),'environment.yml').download_file('/tmp/config-data.yml')

    with open('/tmp/config-data.yml') as f:
      config_data = yaml.load(f)
      if config_data.has_key('environment'):
        for k, v in config_data['environment'].iteritems():
          env_vars[k.upper()]=v

  except:
    None
  finally:
    os.remove('/tmp/config-data.yml') if os.path.exists('/tmp/config-data.yml') else None


with open('/etc/environment', 'w') as f:
  for k, v in env_vars.iteritems():
    f.writelines("%s=%s\n" % (k, v))