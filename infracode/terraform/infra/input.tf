variable "environment" {
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}

variable "loadbalancer_name"{
  description = "Applcation load balancer"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "app_name" {
  description = "Application name"
}

variable "app_image" {
  description = "Application image name"
}

variable "task_count" {
  description = "The number of tasks to run in ECS"
}

variable "service_role_arn_code_deploy" {
  description = "Service role for ECS code deploy"
}