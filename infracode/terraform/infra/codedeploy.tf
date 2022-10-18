resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = "Deployment-${var.app_name}"
}


// AWS Codedeploy Group for each codedeploy app created
resource "aws_codedeploy_deployment_group" "main" {
  count = 1
  app_name               = aws_codedeploy_app.main.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.app_name}-deployment-group"
  service_role_arn       = var.service_role_arn_code_deploy

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${var.environment}-ecs"
    service_name = aws_ecs_service.my-web-service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          aws_lb_listener.my-web-https.arn]
      }

      target_group {
        name = aws_lb_target_group.my-web-tg.name
      }

      target_group {
        name = aws_lb_target_group.my-web-tg-green.name
      }
    }
  }

  lifecycle {
    ignore_changes = [blue_green_deployment_config]
  }
}
