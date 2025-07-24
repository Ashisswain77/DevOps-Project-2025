🚀 Secure CI/CD with AWS, GitHub Actions & Sealed Secrets | DevOps 2025 Project
This project demonstrates how to set up a production-grade CI/CD pipeline using Terraform and AWS CodePipeline, with built-in DevSecOps practices powered by GitHub Actions. It deploys application updates to an EC2 instance securely, runs security validations (tfsec & Trivy), and uses Kubernetes Sealed Secrets for encrypted secret management.

🏗️ Architecture Overview
End-to-end automation pipeline:

Source: GitHub Repository

Build: AWS CodeBuild with buildspec.yml

Deploy: AWS CodeDeploy with appspec.yml and shell scripts

Validation: tfsec + Trivy + Terratest

Secrets: Kubernetes Sealed Secrets

📦 Tech Stack
Category	Tools Used
Infrastructure as Code	Terraform, Terratest
Cloud Platform	AWS (EC2, CodePipeline, CodeBuild, IAM, S3, CodeDeploy)
CI/CD	GitHub Actions
Security	tfsec, Trivy
Secrets	Bitnami Sealed Secrets for Kubernetes
Languages	Go, Shell, YAML

🔰 Prerequisites
AWS CLI configured: aws configure

Terraform installed (v1.3+)

GitHub Personal Access Token (PAT)

Existing EC2 key pair and proper IAM roles

Git installed

Docker (for Trivy and app container)

📁 Folder Structure
bash
Copy
Edit
devops-2025-project/
├── .github/workflows/
│   └── devsecops-pipeline.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── scripts/
│   ├── install.sh
├── examples/
│   ├── appspec.yml
│   ├── buildspec.yml
│   └── scripts/
│       └── install.sh
├── k8s/
│   ├── manifests/
│   │   └── deployment.yaml
│   └── secrets/
│       └── sealed-secret.yaml
├── test/
│   └── terraform_pipeline_test.go
├── README.md
├── .gitignore
├── terraform.tfvars
🧪 Setup Instructions
1. Clone the Project
bash
Copy
Edit
git clone https://github.com/Ashisswain77/devops-2025-project.git
cd devops-2025-project
2. Create terraform.tfvars
Create a file terraform.tfvars in the root and add:

hcl
Copy
Edit
project_name       = "SecureCIProject"
bucket_name        = "ashis-artifact-bucket"
aws_region         = "ap-south-1"
ami_id             = "ami-00c8ac9147e19828e"
instance_type      = "t3.micro"
key_name           = "ashis-key"
github_owner       = "Ashisswain77"
github_repo        = "devops-2025-project"
github_branch      = "main"
github_token       = "<your-github-token>"
instance_tag_key   = "Name"
instance_tag_value = "AppServer"
📛 Note: Make sure .gitignore contains:

Copy
Edit
terraform.tfvars
3. Deploy Infra with Terraform
bash
Copy
Edit
terraform init
terraform plan
terraform apply --auto-approve
✅ Task 1: AWS Pipeline Provisioning
What’s provisioned:

CodePipeline (GitHub → Build → Deploy to EC2)

S3 for artifact storage

IAM roles for EC2, CodeBuild, CodeDeploy

EC2 instance with required tags and access

You need:

buildspec.yml

appspec.yml

scripts/install.sh & scripts/start.sh

✅ Task 2: GitHub Actions with DevSecOps
File: .github/workflows/devsecops-pipeline.yml

Includes:

tfsec scanning of Terraform code

Docker build & Trivy scan

Auto deployment to Kubernetes with decrypted Sealed Secrets

Sample:

yaml
Copy
Edit
name: DevSecOps CI/CD

on:
  push:
    branches: [main]

jobs:
  tf-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tfsec
        uses: aquasecurity/tfsec-action@v1.0.0

  trivy-scan:
    needs: tf-check
    runs-on: ubuntu-latest
    steps:
      - run: docker build -t myapp .
      - run: trivy image myapp
🛡️ Sealed Secrets (Kubernetes)
Create a secret:

bash
Copy
Edit
kubectl create secret generic db-creds \
  --from-literal=username=admin \
  --from-literal=password=pass123 \
  --dry-run=client -o yaml > secret.yaml
Seal it:

bash
Copy
Edit
kubeseal --cert pub-cert.pem -o yaml < secret.yaml > sealed-secret.yaml
Reference in deployment.yaml:

yaml
Copy
Edit
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-creds
        key: username
🧪 Terratest Infrastructure Testing
Setup:

bash
Copy
Edit
go mod init testinfra
go get github.com/gruntwork-io/terratest/modules/terraform
Test File (test/terraform_pipeline_test.go)

go
Copy
Edit
func TestInfra(t *testing.T) {
  tf := &terraform.Options{TerraformDir: "../terraform"}
  defer terraform.Destroy(t, tf)
  terraform.InitAndApply(t, tf)
  output := terraform.Output(t, tf, "codepipeline_name")
  assert.NotEmpty(t, output)
}
Run:

bash
Copy
Edit
go test ./test
🧠 Common Errors & Fixes
Problem	Solution
Source stage fails	Check GitHub token, repo name, and branch
EC2 app not running	Verify user_data, check logs, and CodeDeploy agent
S3 access denied	IAM role for EC2 must allow s3:GetObject

🔮 Future Enhancements
🔁 Blue/Green deployments with traffic shifting

📈 Add Prometheus & Grafana monitoring

🔐 Migrate secrets to AWS Secrets Manager

🔄 Multi-region deployments

👤 Author
Ashis Swain
GitHub: @Ashisswain77
Email: ashisswainofficial77@gmail.com
