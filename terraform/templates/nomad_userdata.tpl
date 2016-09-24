#cloud-config
environment:
  role: ${role}
  project: ${project}
  environment: ${environment}
  s3_config_bucket: acme-config