# Introduction

Repository containing infrastructure as code for the digital showroom project

There are two environments that describe the TEST and PROD configurations.
Each one of these contains various terraform files
```bash
backend.conf # Backend configuration - defines where to store the state file
main.tf # Main file - it lists all the modules necessary to deploy the ENV's infrastructure
provider.tf # Describes which providers are used by the project
<environment-name>.tfvars # Default variable values
```
The `modules` folder contains all the submodules used by the various Terraform environments. These are reusable building blocks that all together make up the infrastructure of digital-showroom.

Terraform is run by automated CI/CD pipelinmes, both when opening a pull request and when pushing on the main branch.

Terraform can also be run locally, but this is not advised.

To do so, while using the correct configuration the following commands can be run:
```bash
terraform init --backend-config=backend.conf
terraform plan -var-file="terraform.tfvars"
```