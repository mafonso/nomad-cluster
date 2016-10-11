#cloud-config
environment:
  role: ${role}
  project: ${project}
  organization: ${organization}
  environment: ${environment}
  consul_bootstrap_expect: 3
  consul_encrypt: null
  atlas_join: true
  atlas_infrastructure: ${organization}/${environment}
  s3_config_bucket: acme-config
preserve_hostname: true
runcmd:
  - instanceid=$(curl -s http://169.254.169.254/latest/meta-data/instance-id | tr -d 'i-')
  - hostn=$(cat /etc/hostname)
  - newhostn="${role}-$instanceid"
  - echo "Exisitng hostname is $hostn"
  - echo "New hostname will be $newhostn"
  - sed -i "s/localhost/$newhostn/g" /etc/hosts
  - sed -i "s/$hostn/$newhostn/g" /etc/hostname
  - hostnamectl set-hostname $newhostn
