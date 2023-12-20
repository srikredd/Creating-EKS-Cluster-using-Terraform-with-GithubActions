# Creating-EKS-Cluster-using-Terraform-with-GithubActions

Prerequisites

AWS Account:
Ensure you have an AWS account with the necessary permissions to create resources like S3 buckets, VPC, and EKS clusters.

AWS CLI:
Install the AWS CLI and configure it with your AWS credentials.

Terraform:
Install Terraform locally on your development machine.

GitHub Account:
Have a GitHub account and a repository to store your Terraform configuration.

Kubectl or ekctl:
Install the ekctl or kubectl locally on your development machine

Steps to Create an Amazon EKS Cluster:

Create an AWS S3 Bucket for Terraform State:
Create an S3 bucket to store the Terraform state files. Replace your-unique-bucket-name with a globally unique bucket name.

Create a VPC with Terraform:
Navigate to the terraform VPC directory and run the following commands
cd /vpc
terraform init
terraform apply

