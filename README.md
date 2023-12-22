Introduction:

This document will guide you with step by step work instruction on how to create EKS Cluster using Github Actions. And it will use the Terraform as IAC for the Infrastructure Automation.

Prerequisites:

1. AWS Account and Cofigured on the Local Machine
2. Install the Terraform 
3. Set the AWS Secret key and Access key in Environment variable in Github

Note:

Do not hard code the Access key and secret key in teraform file.

The creation of EKS Cluster will take multiple steps.

Steps:
1. Creates S3 Bucket to store the Cluster and VPC terraform tf state
2. Create VPC in AWS using Terraform
3. Creating Cluster Infra code 
4. Creating the pipeline for automation using GithubActions

Tools Required:
1. AWS Account
2. Terrform
3. Github Actions(We can define from Github Itself)


1. Create the S3 Bucket

   We can create the S3 Bucket by going through the console or by cli also.

   aws s3api create-bucket --bucket YOUR_BUCKET_NAME --region YOUR_REGION


2. Creating the VPC

Go to the VPC Folder and Run the below comands.
    
    cd /vpc
    terraform init
    terraform plan
    terraform apply 

3. Creating Cluster Infra
 
Can find the configuration file in /cluster directory where we have 3 files
 
   main.tf        - Cluster Infra code
   variables.tf   - Variables which were defined in the main.tf file
   backend.tf     - Bucket confiuration to store the terraform state

4. Creating the pipeline for automation.

Can find the pipeline configuration in the .github/workflows directory

Note:

Here we are using The workflow_dispatch event allows us to manually trigger a workflow run from the GitHub UI.