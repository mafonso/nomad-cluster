# Nomad-cluster


(WIP: this project is fairly outdated now and I'm working of redoing this on recent versions of all the tools.) 

##Introdution

This is a sample project that demostrate how to build a distributed platform to run containerized microservices based on hashicorp tools.  

## The tech stack
* [Nomad](https://www.nomadproject.io/) provides the cluster management/scheduling.

* [Consul](consul.io) provides the service discovery and distributed key/value store.

* [Vault](https://www.vaultproject.io) manages the application's secrets. 

* [Terraform](terraform.io) manages the infrastructure, using [Amazon AWS](aws.amazon.com) resources

* [Packer]() is used to build [AMIs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) for the different instance roles using [Ansible](https://www.ansible.com/) as a provisioning tool.



##Getting started

Sorry no tooling yet

Set Atlas token and AWS credentials.

```
export ATLAS_TOKEN="EXAMPLEwzEMjA.atlasv1.EXAMPLELi8aqJkuMj6aB9TKoP3TDJUtXbJVcfdskgASaYgEXAMPLE"
export AWS_PROFILE=acme
```

Build AMIs
```
cd packer

packer build -var image_name=nat aws.json  (if using nat boxes as Nat Gateway is not on Free tier) 

packer build -var image_name=bastion aws.json

packer build -var image_name=consul aws.json

packer build -var image_name=nomad aws.json

```


Deploy with terraform
```
cd terraform

terraform plan  -input=false  (verify plan) 

terraform apply  -input=false
```

You should be able to ssh into the bastion host and then to either a consul or nomad server node.
