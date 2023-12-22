EKS Cluster Creation with GitHub Actions and Terraform
This guide provides step-by-step instructions on creating an Amazon EKS Cluster using GitHub Actions and Terraform as Infrastructure as Code (IAC).

Prerequisites:
AWS Account: Configure AWS credentials on your local machine.
Terraform: Install Terraform locally.
GitHub Actions:
Set up your AWS Secret Key and Access Key in GitHub Actions environment variables.
Note:
Avoid hard-coding access keys and secret keys in the Terraform files.

Steps:
1. Create the S3 Bucket
Create an S3 Bucket to store the Terraform tf state:

bash
Copy code
aws s3api create-bucket --bucket YOUR_BUCKET_NAME --region YOUR_REGION

2. Create VPC
Navigate to the vpc directory and run:

bash
Copy code
cd /vpc
terraform init
terraform plan
terraform apply

3. Create Cluster Infrastructure
Find the cluster infrastructure code in the /cluster directory with the following files:

main.tf: Cluster infrastructure code.
variables.tf: Variables defined in main.tf.
backend.tf: Bucket configuration to store the Terraform state.

4. Create Pipeline for Automation
Find the pipeline configuration in the .github/workflows directory. Here, we use the workflow_dispatch event to manually trigger a workflow run from the GitHub UI.

Tools Required:
AWS Account
Terraform
GitHub Actions (defined from GitHub itself)

Important:
The workflow_dispatch event allows manual triggering of a workflow run from the GitHub UI.


