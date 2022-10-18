/* ECS cluster resource */
resource "aws_ecs_cluster" "my-web-cluster" {
  name = "${var.environment}-ecs"
}

/* Capacity provider as FARGATE */
resource "aws_ecs_cluster_capacity_providers" "my-web-cluster" {
  cluster_name = aws_ecs_cluster.my-web-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# /* Getting task definition */
# data "aws_ecs_task_definition" "latest_task" {
#   task_definition = aws_ecs_task_definition.my-web.arn
#   depends_on = [aws_ecs_task_definition.my-web]
# }

/* Creating Task definition on ECS */
resource "aws_ecs_task_definition" "my-web" {
  family                   = "service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-api"
      image     = "${var.app_image}"   ### "312397576406.dkr.ecr.us-east-1.amazonaws.com/dev-repo:latest" ##
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

/* ECS service with CODE DEPLOY as controller */
resource "aws_ecs_service" "my-web-service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.my-web-cluster.id
  task_definition = aws_ecs_task_definition.my-web.arn
  desired_count   = var.task_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private_subnet.*.id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my-web-tg.arn
    container_name   = "${var.app_name}-api"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition,load_balancer,desired_count]
  }
  deployment_controller {
    type = "CODE_DEPLOY"
  }

}

/* Security group for ECS tasks  */
resource "aws_security_group" "ecs_tasks" {
  name        = "myapp-ecs-tasks-security-group"
  description = "allow inbound access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
