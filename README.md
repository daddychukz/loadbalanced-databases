## LoadBalancing MySQL Database with HAProxy
This is an automation script that deploys a One Master, two Slaves Loadbalanced Mysql Databases to AWS Cloud Platform.



### Technologies used:
- **Terraform** - *For configuration management*
- **Ansible** - *For provisioning*
- **AWS** - *Cloud Platform*

### Steps to deploy:
- Setup Terraform and Ansible on your local computer
- Terraform version used in deploying this is v0.11.7
- Ansible version used is v2.5.0
- Rename `terraform.tfvars.tmpl` file to `terraform.tfvars` and supply variables
- Run Terraform Plan
- Run Terraform apply
- Launch the HAProxy on port 9201 `i.e <ip>:9201/stats)` to see the activities on both the master and slaves