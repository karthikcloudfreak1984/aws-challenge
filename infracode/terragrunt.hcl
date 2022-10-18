terraform {

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    optional_var_files = [
      find_in_parent_folders("region.tfvars"),
    ]
  }
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::434442716997:role/terragrunt_role"
  }
  
}
variable "aws_region" {
  description = "AWS region to create infrastructure"
  type        = string
}
EOF
}

# Backend to store the Terraform state files for the environment
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "terraform-state-ecs-oct"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}