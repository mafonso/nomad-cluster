organization = "acme"
project      = "nomad"
environment  = "dev"
region       = "eu-west-1"
cidr_block   = "10.8.0.0/16"
key_name     = "dev"

domain_name_servers = ["127.0.0.1"]

consul_servers = 3
nomad_servers = 3
worker_nodes = 3