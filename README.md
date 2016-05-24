#Nomad-cluster


##Introdution

This is a sample project that demostrate how to build a distributed platform to run containerized microservices based on hashicorp tools.  

## The tech stack
* [Nomad](https://www.nomadproject.io/) provides the cluster management/scheduling. 

* [Consul](consul.io) provides the service discovery and distributed key/value store.  

* [Vault](https://www.vaultproject.io) manages the application´s secrets. 

* [Terraform](terraform.io) manages the infrastructure, unsing [Amazon AWS](aws.amazon.com) resources

* [Packer]() is used to build [AMIs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) for the different instance roles using [Ansible](https://www.ansible.com/) as a provisioning tool.


## Design principles

