# Terraform Project 1 - AWS VPC and EC2 Infrastructure

## Repository

https://github.com/jsonam21/Devops_Demo_Project/tree/master/terraform


## Overview

This project provisions a basic AWS infrastructure using Terraform.

The infrastructure includes:

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- EC2 Instance

The project follows a modular Terraform structure and is intended for learning Infrastructure as Code (IaC) and AWS provisioning.

---

## Architecture

```text
AWS
│
├── VPC
│   └── Public Subnet
│
├── Internet Gateway
│
├── Route Table
│   └── Route Association
│
├── Security Group
│
└── EC2 Instance
```

---

## Project Structure

```text
terraform-project-1/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
│
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Prerequisites

Install the following tools:

- Terraform >= 1.0
- AWS CLI v2
- AWS Account
- IAM User with programmatic access

Verify installations:

```bash
terraform version
aws --version
```

---

## AWS Authentication

Configure AWS CLI credentials:

```bash
aws configure
```

Example:

```text
AWS Access Key ID: **************
AWS Secret Access Key: **************
Default region: ap-south-1
Output format: json
```

Verify:

```bash
aws sts get-caller-identity
```

---

## Variables

The project uses the following variables:

| Variable | Description |
|-----------|-------------|
| aws_region | AWS Region |
| project_name | Project Name |
| vpc_cidr | VPC CIDR Block |
| public_subnet_cidr | Public Subnet CIDR |
| availability_zone | Availability Zone |
| instance_type | EC2 Instance Type |

Example:

```hcl
aws_region         = "ap-south-1"
project_name       = "devops-demo"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "ap-south-1a"
instance_type      = "t3.micro"
```

---

## Terraform Workflow

### Initialize

```bash
terraform init
```

### Format

```bash
terraform fmt
```

### Validate

```bash
terraform validate
```

### Generate Execution Plan

```bash
terraform plan
```

### Apply Infrastructure

```bash
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

---

## Outputs

Terraform outputs:

- VPC ID
- Public Subnet ID
- EC2 Instance ID
- EC2 Public IP

Example:

```bash
Outputs:

vpc_id = "vpc-xxxxxxxx"
public_subnet_id = "subnet-xxxxxxxx"
instance_id = "i-xxxxxxxx"
public_ip = "xx.xx.xx.xx"
```

---

## Security Considerations

This project is intended for learning purposes.

Current Security Group Rules:

| Port | Purpose |
|--------|---------|
| 22 | SSH |
| 80 | HTTP |

Ingress is currently open to:

```text
0.0.0.0/0
```

For production environments, restrict access to trusted IP addresses.

---

## Cost Considerations

This project was designed to be AWS Free Tier friendly.

Recommendations:

- Use free-tier eligible EC2 instance types.
- Avoid NAT Gateways.
- Avoid Load Balancers.
- Destroy resources when not in use.

After testing:

```bash
terraform destroy
```

---

## Learning Objectives

This project demonstrates:

- Terraform Modules
- Variables and Outputs
- AWS Provider Configuration
- VPC Provisioning
- EC2 Provisioning
- Security Groups
- Infrastructure as Code Best Practices
- Terraform State Management

---

## Author

Created as part of a DevOps and Terraform learning portfolio.