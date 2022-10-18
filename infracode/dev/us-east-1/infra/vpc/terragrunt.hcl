
# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders()
}

locals {
    terraform_config = read_terragrunt_config(find_in_parent_folders("terraform_config.hcl"))
    tag = local.terraform_config.locals.tag
}

# Expose the base source URL so different versions of the module can be deployed in different environments. This will
# be used to construct the terraform block in the child terragrunt configurations.
terraform {
  source = "../../../../terraform//infra"
}

inputs = {
  environment = "dev"
  vpc_cidr = "10.0.0.0/16"
  region = "us-east-1"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets_cidr  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  loadbalancer_name = "app"
  app_name = "web_app"
  app_image = "434442716997.dkr.ecr.us-east-1.amazonaws.com/web:v2"
  task_count = 2
  service_role_arn_code_deploy = "arn:aws:iam::434442716997:role/ECS-service-role"
}
