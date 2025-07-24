variable "aws_region" {
  default = "eu-north-1"
}

variable "project_name" {
  default = "MyApp"
}

variable "github_token" {
  description = "GitHub PAT"
  type        = string
}

variable "github_owner" {
  description = "GitHub username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo name"
  type        = string
}

variable "github_branch" {
  default = "main"
}

variable "bucket_name" {
  description = "Artifact bucket name"
  type        = string
}

variable "ami_id" {
  default     = "ami-0f5ee92e2d63afc18" # Amazon Linux 2023
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_tag_key" {
  default = "Name"
}

variable "instance_tag_value" {
  default = "webserver"
}
