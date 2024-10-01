
# Terraform Multi-Environment AWS Infrastructure

This repository contains Terraform configurations for deploying a multi-environment infrastructure on AWS. The project automates the deployment of development, staging, and production environments, including features like load balancing, auto-scaling, and secure secret management.

## Project Overview
This project sets up a cloud-based infrastructure using AWS and Terraform, focusing on:

* Multiple environments (development, staging, production).
* Vault for secret management.
* Consul for service discovery and networking.
* Auto-scaling EC2 instances for fault tolerance.
* Application Load Balancer (ALB) for traffic distribution.
* S3 for static content hosting.
* Route 53 for DNS routing.

## Features
* **Multi-environment setup:** Deploy separate environments for development, staging, and production.
* **Terraform automation:** Infrastructure as code, using Terraform for provisioning and managing AWS resources.
* **Vault integration:** Secure management of secrets across environments.
* **Consul integration:** Service discovery and networking within your AWS VPC.
* **Auto-scaling:** Automatically scale EC2 instances based on traffic.
* **Load balancing:** Distribute incoming traffic efficiently with an AWS Application Load Balancer (ALB).

## Task List
 - [x]   Setup multi-environment infrastructure (development, staging, production)
 - [x]   Create S3 buckets for static website hosting
 - [x]   Configure Route 53 for DNS routing
 - [x]   Setup VPC with public and private subnets
 - [x]   Configure AWS Lambda for serverless backend logic
 - [ ]   Implement Application Load Balancer (ALB) with auto-scaling EC2 instances
 - [ ]   Integrate Consul for service discovery
 - [ ]   Integrate Vault for secret management
 - [ ]   Complete deployment for all environments and test

## Key Terraform Files
* `main.tf`: Defines the primary infrastructure components like VPC, EC2, Load Balancers, and S3.
* `variables.tf`: Declares the input variables used for customizing the infrastructure.
* `terraform.tfvars`: Specifies the actual values for the declared variables.
* `terraform.tfstate`: Maintains the state of the deployed infrastructure.
* `modules/`: Contains reusable Terraform modules for common resources (e.g., EC2, ALB, S3).

## Prerequisites
* Terraform: Install Terraform to manage infrastructure as code.
* AWS CLI: Install and configure AWS CLI with your credentials.
* Consul & Vault: Ensure you have Consul and Vault services available or set up as part of your infrastructure.

## Setup Instructions
1. **Clone the repository**
```
git clone https://github.com/AliDavoodi98/terraform-multi-env-infra.git
cd terraform-multi-env-infra/Terraform
```
2. **Configure AWS Credentials**
Make sure your AWS CLI is configured properly:
```
aws configure
```
3. **Customize Variables**
Edit the terraform.tfvars file to configure values for your AWS setup (e.g., region, instance size, VPC CIDR blocks, etc.).
```
aws_region = "us-east-1"
instance_type = "t2.micro"
```
4. **Initialize and Apply Terraform**
```
terraform init
terraform apply
```
This will provision all the resources specified in the Terraform files, including VPC, EC2 instances, Vault, Consul, ALB, and more.

5. **Destroy the Infrastructure**
To clean up and remove the deployed infrastructure, run:
```
terraform destroy
```
> [!NOTE]
> Ensure that `terraform.tfstate` and `terraform.tfstate.backup` are securely stored, especially if sharing the repository publicly.
If you’re storing sensitive information in `terraform.tfvars`, avoid pushing it to the repository by adding it to `.gitignore`.

> [!NOTE]
> Always remember to destroy resources when they are no longer in use to avoid unnecessary costs.
