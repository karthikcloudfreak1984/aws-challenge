# aws-challenge

## Summary:

This setup uses terragrunt as a wrapper for terraform to create a VPC from scratch with Private and Public subnet. It has a load balancer with listener configured to redirect traffic on port 80 to port 443. The application load balancer has a target group configured which has ECS tasks running which using as simple nginx container running on ECS cluster. These tasks pull image from ECR which are build and pushed through Github actions.

This setup has a workflows configured to deploy the infra,build and deploy the app through Code Deploy using Blue/Green Deployment.

## Before Blue Green Deploy: 
![image](https://user-images.githubusercontent.com/99579300/196526890-5f9dd37e-006f-471e-b7c7-d2e903b511f2.png)

## After Blue Green Deploy:
![image](https://user-images.githubusercontent.com/99579300/196526938-acbe6067-807a-4872-85c7-cced15e41cc5.png)

## Screenshots for Code Deploy:
![image](https://user-images.githubusercontent.com/99579300/196526977-d963440d-bf02-47ce-8181-2b88cb1bad0e.png)
![image](https://user-images.githubusercontent.com/99579300/196527014-0322b45b-f759-426e-9619-7ec96947235f.png)

## GitActions Deployment completion:
![image](https://user-images.githubusercontent.com/99579300/196527047-62ff3fd4-072f-4cab-a17c-b4db818a5fcc.png)

# Architecture


<img width="844" alt="image" src="https://user-images.githubusercontent.com/99579300/196616373-26b2fd6c-df49-471f-9a17-e754e1defb36.png">

