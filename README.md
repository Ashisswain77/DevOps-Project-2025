# 🚀 Secure CI/CD with AWS, GitHub Actions & Sealed Secrets | DevOps 2025 Project

This project implements a **production-ready CI/CD pipeline** using **Terraform** and **AWS CodePipeline**, enhanced with modern **DevSecOps** best practices. Application updates are triggered from GitHub pushes, built with CodeBuild, deployed with CodeDeploy, and validated using Terratest, tfsec, and Trivy. Secrets are securely managed using **Kubernetes Sealed Secrets**.

---

## 🏗️ Architecture Overview

An end-to-end pipeline:
- 🧑‍💻 Source: GitHub Repository (`main` branch)
- 🏗️ Build: AWS CodeBuild with `buildspec.yml`
- 🚀 Deploy: AWS CodeDeploy with EC2 and `appspec.yml`
- 🔐 Secrets: Kubernetes Sealed Secrets
- 🛡️ Security Scans: tfsec for Terraform, Trivy for Docker
- 🧪 Testing: Terratest for IaC validation

---

## 🌐 Live Demo Links

| Component                | Link                                                                 |
|--------------------------|----------------------------------------------------------------------|
| 🔗 GitHub Repository      | [devops-2025-project](https://github.com/Ashisswain77/devops-2025-project) |
| 🔐 Sealed Secret YAML     | [sealed-secret.yaml](https://github.com/Ashisswain77/devops-2025-project/blob/main/k8s/secrets/sealed-secret.yaml) |
| 📦 Kubernetes Deployment  | [deployment.yaml](https://github.com/Ashisswain77/devops-2025-project/blob/main/k8s/manifests/deployment.yaml) |
| ⚙️ GitHub Actions Workflow| [CI/CD Pipeline](https://github.com/Ashisswain77/devops-2025-project/blob/main/.github/workflows/devsecops-pipeline.yml) |

> 🔗 EC2 public app demo link: (Update once deployed)

---

## 🧰 Tech Stack

| Category       | Tools |
|----------------|-------|
| IaC            | Terraform, Terratest |
| Cloud Platform | AWS EC2, CodePipeline, CodeBuild, IAM, S3 |
| CI/CD          | GitHub Actions |
| Security       | tfsec, Trivy |
| Secrets        | Sealed Secrets (Bitnami) |
| Runtime        | Docker, Kubernetes |
| Language       | Go, YAML, Shell |

---

## 🔧 Project Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Ashisswain77/devops-2025-project.git
cd devops-2025-project
```

### 2️⃣ Configure AWS CLI
```bash
aws configure
```

### 3️⃣ Create `terraform.tfvars`
```hcl
project_name       = "myApp"
bucket_name        = "your-unique-bucket"
aws_region         = "ap-south-1"
ami_id             = "ami-00c8ac9147e19828e"
instance_type      = "t3.micro"
key_name           = "your-ec2-keypair"
github_owner       = "Ashisswain77"
github_repo        = "devops-2025-project"
github_branch      = "main"
github_token       = "your-github-token"
instance_tag_key   = "Name"
instance_tag_value = "AppServer"
```

> 🚩 **Do not commit this file to GitHub.**

---

## 📦 Terraform Deployment

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

---

## 🔬 Infrastructure Testing with Terratest

File: `test/terraform_pipeline_test.go`

```go
func TestPipelineInfra(t *testing.T) {
  tf := &terraform.Options{ TerraformDir: "../" }
  defer terraform.Destroy(t, tf)
  terraform.InitAndApply(t, tf)
  output := terraform.Output(t, tf, "codepipeline_name")
  assert.NotEmpty(t, output)
}
```

Run test:
```bash
go test ./test
```

---

## 🔐 Sealed Secrets Setup

```bash
kubectl create secret generic db-creds \
  --from-literal=username=admin \
  --from-literal=password=1234 \
  --dry-run=client -o yaml > secret.yaml

kubeseal --cert pub-cert.pem -o yaml < secret.yaml > sealed-secret.yaml
```

> Save sealed secret to: `k8s/secrets/sealed-secret.yaml`

---

## 📄 GitHub Actions Workflow

File: `.github/workflows/devsecops-pipeline.yml`

```yaml
name: DevSecOps Pipeline

on:
  push:
    branches: [main]

jobs:
  terraform-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.5
      - run: terraform init
      - run: terraform validate
      - uses: aquasecurity/tfsec-action@v1.0.0

  docker-scan:
    needs: terraform-check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: docker build -t myapp:latest .
      - run: trivy image --exit-code 1 myapp:latest

  deploy:
    needs: docker-scan
    runs-on: ubuntu-latest
    steps:
      - run: kubectl apply -f k8s/secrets/sealed-secret.yaml
      - run: kubectl apply -f k8s/manifests/
```

---

## 📁 Folder Structure

```
devops-2025-project/
├── .github/workflows/
│   └── devsecops-pipeline.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── scripts/
│   ├── install.sh
├── examples/
│   ├── buildspec.yml
│   ├── appspec.yml
│   └── scripts/install.sh
├── k8s/
│   ├── secrets/sealed-secret.yaml
│   └── manifests/deployment.yaml
├── test/
│   └── terraform_pipeline_test.go
├── README.md
├── .gitignore
├── terraform.tfvars (not committed)
```

---

## 🧠 Troubleshooting

| Issue                            | Solution                                                |
|----------------------------------|----------------------------------------------------------|
| `HEALTH_CONSTRAINTS` in CodeDeploy | EC2 instance role must allow `s3:GetObject`              |
| CodeDeploy agent not running     | Verify `install.sh` installs and starts `codedeploy-agent` |
| Source stage fails               | Check `github_token`, repo, and branch in tfvars         |
| Docker scan fails                | Fix vulnerabilities or adjust Trivy severity flags       |

---

## 🧭 Future Enhancements

- 🌀 Blue/Green deployments
- 🛠️ DAST/SAST scanners
- 📊 Grafana dashboards
- ☁️ AWS Secrets Manager support
- 🌍 Multi-cloud support

---

## 🪪 License

MIT License

---

## 👤 Maintainer

**Ashis Swain**  
GitHub: [@Ashisswain77](https://github.com/Ashisswain77)  
Email: ashisswainofficial77@gmail.com
