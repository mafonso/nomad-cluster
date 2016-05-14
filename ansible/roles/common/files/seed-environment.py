#!/usr/bin/env python

import os
import yaml

env_vars = {}

with open('/var/lib/cloud/instance/user-data.txt') as f:
  user_data = yaml.load(f)
  if user_data.has_key('environment'):
    for k, v in user_data['environment'].iteritems():
      env_vars[k.upper()]=( "%s=%s\n" % (k.upper(), v) )

with open('/etc/environment', 'w') as f:
  f.writelines(env_vars.values())
