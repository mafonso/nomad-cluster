#cloud-config
environment:
  role: ${role}
  project: ${project}
  environment: ${environment}
  consul_bootstrap_expect: 3
  s3_config_bucket: acme-config