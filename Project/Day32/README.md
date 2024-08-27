### **Project Overview: Deploying a Multi-Tier Web Application Using Amazon ECS (Without Load Balancer and API Gateway)**

This project is designed to test participants' knowledge of Amazon ECS (Elastic Container Service) by deploying a multi-tier web application on AWS without using a Load Balancer or API Gateway. The project involves setting up an ECS cluster, defining task definitions, creating services, and ensuring proper networking and security configurations using VPC, subnets, security groups, and IAM roles.

### **Estimated Duration: 2 Hours**

### **Project Objectives:**

* Set up an ECS Cluster using the Fargate launch type.  
* Deploy a web application consisting of multiple containers (frontend and backend).  
* Implement direct communication between frontend and backend services.  
* Manage ECS tasks, services, and scaling policies.  
* Ensure network security with VPC, subnets, security groups, and IAM roles.

### **Project Requirements:**

* **ECS Cluster**: Create an ECS Cluster using Fargate.  


* **Task Definitions**: Define task definitions for web and backend services.  

![alt text](p1/TaskDefFrontend.png)

![alt text](p1/TaskDefBack.png)

* **Services**: Create ECS services for each tier (frontend and backend) without using a Load Balancer or API Gateway.  

![alt text](p1/ECS2Service.png)

* **Security Groups**: Configure security groups to allow traffic between services directly.  



* **IAM Roles**: Create and assign IAM roles for ECS tasks.  
* **VPC and Networking**: Create a VPC with public and private subnets, ensuring proper routing of traffic without a NAT gateway.  

![alt text](p1/VPC.png)

* **Secrets Management**: Use AWS Secrets Manager or SSM Parameter Store to manage database credentials.  
* **Scaling**: Implement auto-scaling policies for the ECS services.

### **Project Deliverables:**

#### **1\. ECS Cluster Setup**

* Create an ECS cluster using the Fargate launch type.  
* Ensure the cluster is running in a VPC with public and private subnets.

#### **2\. Task Definitions**

* Create task definitions for two services:  
  * **Frontend Service**: A container running an NGINX server serving static content.  
  * **Backend Service**: A container running a Python Flask API connected to an RDS instance.  
* Define CPU and memory requirements for each container.  
* Configure environment variables and secrets for connecting to the database.

#### **3\. RDS Instance Setup**

* Launch an RDS instance using the free tier template with MySQL.  

**RDS Created**

![alt text](p1/RDSCreated.png)

* Ensure the RDS instance is in a private subnet.
* accessible only by the backend service.  

![alt text](p1/PrivatlyAccessible.png)

* Store database credentials in AWS Secrets Manager or SSM Parameter Store.

#### **4\. ECS Services Setup**

* Deploy the frontend and backend services using ECS.  
* Ensure that the frontend service can communicate directly with the backend service using the backend service's private IP or DNS name.

#### **5\. Networking and Security**

* Set up VPC with public subnets for the frontend service and private subnets for the backend service and RDS.  
* Create security groups to:  
  * Allow the frontend service to communicate with the backend service.  
  * Allow the backend service to connect to the RDS instance.  
  * Ensure that the frontend service is accessible from the internet while restricting access to the backend service.  
* Create IAM roles and policies for ECS tasks to allow access to S3, Secrets Manager, and other required services.

#### **6\. Scaling and Monitoring**

* Implement auto-scaling policies based on CPU and memory usage for both services.  
* Set up CloudWatch alarms to monitor service performance and trigger scaling events.

#### **7\. Deployment and Validation**

* Deploy the multi-tier web application using the ECS services.  
* Validate the communication between the frontend and backend services.  
* Test the application to ensure it functions as expected.  
* Monitor the application’s performance using CloudWatch and other AWS monitoring tools.

#### **8\. Resource Cleanup**

* Once the deployment is validated, ensure that all AWS resources are properly terminated:  

![alt text](p1/ResourceDestroyed.png)

  * Stop and delete ECS tasks and services.  
  * Delete the ECS cluster.  
  * Terminate the RDS instance.  
  * Clean up any associated S3 buckets, IAM roles, and security groups.

### **Key Evaluation Criteria:**

* Proper setup and configuration of ECS, RDS, and networking components.  
* Correct implementation of security groups, IAM roles, and policies.  
* Successful deployment and testing of the multi-tier web application.  
* Proper management of ECS tasks and services, including scaling policies.  
* Complete cleanup of all AWS resources after the project is completed.

