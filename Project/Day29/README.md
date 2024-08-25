**Day 28**

### **Terraform Overview**

**Terraform** is an open-source infrastructure as code (IaC) tool created by HashiCorp. It allows users to define and provision infrastructure using a high-level configuration language known as HashiCorp Configuration Language (HCL) or JSON. Terraform enables you to automate the creation, modification, and destruction of infrastructure resources across various cloud providers and on-premises environments, ensuring that infrastructure is managed consistently.

### **Architecture of Terraform**

Terraform's architecture can be broken down into several key components:

1. **Configuration Files**:  
   * **Terraform Configuration**: Users write Terraform configuration files in HCL or JSON to describe the desired state of the infrastructure. These files define resources like servers, databases, networks, and load balancers.  
   * **Modules**: A module is a container for multiple resources that are used together. Modules allow you to create reusable infrastructure components.  
2. **Terraform Core**:  
   * **Terraform Core** is the heart of Terraform. It reads the configuration files, builds a dependency graph of resources, and communicates with the plugins to provision the infrastructure. Terraform Core has two primary functions:  
     * **Resource Graph Construction**: It builds a graph of all resources defined in the configuration, allowing it to figure out the correct order to create, update, or delete resources.  
     * **Execution Plan**: It generates an execution plan that details the steps Terraform will take to achieve the desired state.  
3. **Providers**:  
   * **Providers** are the plugins that interface with the APIs of various cloud platforms (e.g., AWS, Azure, GCP), services, and other systems (e.g., GitHub, Datadog). Each provider offers a set of resources and data sources specific to a particular service or platform.  
   * Terraform supports a wide variety of providers, and each provider has its own configuration options and set of available resources.  
4. **State**:  
   * **Terraform State** is a file that Terraform uses to keep track of the infrastructure it manages. The state file records the mappings between the Terraform resources in your configuration files and the actual resources in your infrastructure.  
   * The state file allows Terraform to detect changes in infrastructure and to create, modify, or delete resources accordingly. State files can be stored locally or remotely in a shared storage backend (e.g., AWS S3, HashiCorp Consul, Terraform Cloud).  
5. **CLI Commands**:  
   * Terraform provides a set of command-line interface (CLI) commands to interact with its functionality:  
     * **terraform init**: Initializes a Terraform working directory, downloading necessary plugins.  
     * **terraform plan**: Creates an execution plan by comparing the current state with the desired state defined in the configuration files.  
     * **terraform apply**: Applies the changes required to reach the desired state.  
     * **terraform destroy**: Destroys the infrastructure managed by Terraform.

### **Terraform Workflow**

1. **Write Configuration**: Write infrastructure as code in configuration files.  
2. **Initialize**: Run `terraform init` to initialize the working directory and download the necessary providers.  
3. **Format (not mandatory):** Formats the script properly  
4. **Validate (not mandatory):** Check for syntax error, if any.  
5. **Plan**: Run `terraform plan` to generate an execution plan that shows what Terraform will do.  
6. **Apply**: Run `terraform apply` to apply the changes and provision the infrastructure.  
7. **Manage**: Use `terraform apply` and `terraform destroy` to manage changes to your infrastructure over time.

### **Use Cases for Terraform**

Terraform is widely used in various scenarios, including:

1. **Multi-Cloud Deployments**:  
   * Terraform supports multiple cloud providers (e.g., AWS, Azure, Google Cloud), allowing users to define infrastructure that spans multiple clouds. This is particularly useful for organizations adopting a multi-cloud strategy.  
2. **Infrastructure as Code (IaC)**:  
   * Terraform allows infrastructure to be defined in code, versioned, and managed just like software. This enables teams to collaborate on infrastructure changes, track modifications, and automate deployments.  
3. **Provisioning and Scaling**:  
   * Terraform automates the provisioning and scaling of infrastructure resources. For example, you can use Terraform to create and manage EC2 instances, load balancers, and VPCs in AWS.  
4. **Self-Service Infrastructure**:  
   * Terraform can be integrated with CI/CD pipelines and other automation tools to provide self-service infrastructure to developers. Developers can use pre-defined Terraform modules to deploy their environments without needing to interact with cloud consoles.  
5. **Disaster Recovery**:  
   * Terraform can be used to define disaster recovery environments. In the event of a failure, Terraform can quickly recreate the infrastructure in a different region or cloud provider.  
6. **Immutable Infrastructure**:  
   * Terraform promotes the concept of immutable infrastructure, where servers and resources are replaced rather than modified. This approach reduces the risk of configuration drift and ensures consistency across environments.  
7. **Compliance and Governance**:  
   * Terraform allows organizations to enforce compliance and governance policies by defining infrastructure in code. Infrastructure changes can be reviewed, approved, and audited before being applied.

### **Benefits of Terraform**

* **Consistency**: Terraform ensures that infrastructure is consistently deployed and managed across different environments.  
* **Scalability**: Terraform can manage large-scale infrastructure, making it suitable for both small teams and enterprise organizations.  
* **Reusability**: Modules and configurations can be reused across different projects, reducing duplication and errors.  
* **Declarative**: Terraform's declarative language allows users to define the desired state of infrastructure without worrying about the steps to achieve it.

**Terraform Installation**

[**Install | Terraform | HashiCorp Developer**](https://developer.hashicorp.com/terraform/install)

[**Install | Terraform | HashiCorp Developer**](https://developer.hashicorp.com/terraform/install\#linux) **(Linux)**

**History of Terraform Lifecycle Deployment (Including the setup)**

    *1  clear*  
    *2  sudo apt-get update*  
    *3  wget \-O- https://apt.releases.hashicorp.com/gpg | sudo gpg \--dearmor \-o /usr/share/keyrings/hashicorp-archive-keyring.gpg*  
    *4  echo "deb \[signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg\] https://apt.releases.hashicorp.com $(lsb\_release \-cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list*  
    *5  sudo apt update && sudo apt install terraform*  
    *6  clear*  
    *7  mkdir .aws*  
    *8  nano .aws/config*  
    *9  nano .aws/credentials*  
   *10  export AWS\_ACCESS\_KEY\_ID=A"Enter_Value"*  
   *11  export AWS\_SECRET\_ACCESS\_KEY="Enter_Value"*  
   *12  terraform*  
   *13  clear*  
   *14  terraform \--version*  
   *15  mkdir terraform-demo*  
   *16  cd terraform-demo*  
   *17  ls*  
   *18  nano main.tf*  
   *19  terraform init*  
   *20  terraform fmt*  
   *21  terraform validate*  
   *22  clear*  
   *23  terraform plan*  
   *24  terraform apply*  
   *25  history*

**State Management in Terraform** 

* A file named as **terraform.tfstate** gets automatically created upon execution of terraform apply command.  
* This file stores the details of the resources deployed using main.tf file

### **Project: Deploying a Multi-Tier Architecture Application on AWS using Terraform**

**Lab Access**

**Allowed Region (Choose Any One) :** us-east-1, us-east-2, us-west-1, us-west-2

#### **Project Objective:**

This project will assess your ability to deploy a multi-tier architecture application on AWS using Terraform. The deployment will involve using Terraform variables, outputs, and change sets. The multi-tier architecture will include an EC2 instance, an RDS MySQL DB instance, and an S3 bucket.

#### **Project Overview:**

You are required to write Terraform configuration files to automate the deployment of a multi-tier application on AWS. The architecture should consist of:

1. **EC2 Instance**: A `t2.micro` instance serving as the application server.  
2. **RDS MySQL DB Instance**: A `t3.micro` instance for the database backend.  
3. **S3 Bucket**: For storing static assets or configuration files.

**See My Current Directory Structure for Modules and backend s3**
```
.
├── backend.tf
├── main.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   └── variable.tf
│   ├── s3
│   │   ├── main.tf
│   │   └── variable.tf
│   └── security_group
│       ├── main.tf
│       └── variable.tf
├── notes
│   └── Modules
├── provider.tf
├── README.md
└── terrform.tfvars
```

#### **Specifications:**

* **EC2 Instance**: Use the `t2.micro` instance type with a public IP, allowing HTTP and SSH access.  

**modules/ec2/main.tf**

```hcl
resource "aws_instance" "inst-module" {
    instance_type = var.instance_type
    ami = var.instance_ami
    vpc_security_group_ids = var.vpc_security_group_ids
    

    tags = {
        Name = var.instance_tag
    }
}

output "Instance_Public_ip" {
    value = aws_instance.inst-module.public_ip
}
```

**To make it use of variable instead of hardcoded use variable.tf**

```hcl
variable "aws_sg_name" {
    type = string
}
variable "ingress_ssh" {
    type = object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    })
    default = {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
}
variable "ingress_http" {
    type = object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    })
    default = {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}
variable "ingress_https" {
    type = object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    })
    default = {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}

variable "vpc_id" {
  type = string
  
}
```
**modules/security_group/main.tf**

```hcl
# Create Security Group by Module

resource "aws_security_group" "ec2-sg" {
    name = var.aws_sg_name
    vpc_id = "Enter_custom_vpc_id if you want to use existing vpc instead of create your custom vpc"

    ingress {
        from_port = var.ingress_ssh.from_port
        to_port = var.ingress_ssh.to_port
        protocol = var.ingress_ssh.protocol
        cidr_blocks = var.ingress_ssh.cidr_blocks
    }
    ingress {
        from_port = var.ingress_http.from_port
        to_port = var.ingress_http.to_port
        protocol = var.ingress_http.protocol
        cidr_blocks = var.ingress_http.cidr_blocks
    }
    ingress {
        from_port = var.ingress_https.from_port
        to_port = var.ingress_https.to_port
        protocol = var.ingress_http.protocol
        cidr_blocks = var.ingress_https.cidr_blocks
    }
     ingress {
         from_port = var.ingress_icmp.from_port
         to_port = var.ingress_icmp.to_port
         protocol = var.ingress_http.protocol
         cidr_blocks = var.ingress_icmp.cidr_blocks
     }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
output "ec2_sg_id" {
    value = aws_security_group.ec2-sg.id 
}
output "sg_name" {
    value = aws_security_group.ec2-sg.name_prefix
}
```

**modules/security_group/variable.tf**

```hcl
variable "aws_sg_name" {
    type = string
}
variable "ingress_ssh" {
    type = object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    })
    default = {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
}
variable "ingress_http" {
    type = object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    })
    default = {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}
variable "ingress_https" {
    type = object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    })
    default = {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}
 variable "ingress_icmp" {
     type = object({
       from_port = number
       to_port = number
       protocol = string
       cidr_blocks = list(string)
     })
     default = {
       from_port = -1
       to_port = -1
       protocol = "icmp"
       cidr_blocks = [ "0.0.0.0/0" ]
     }
  
 }

variable "vpc_id" {
  type = string
  
}
```


* **RDS MySQL DB Instance**: Use the `t3.micro` instance type with a publicly accessible endpoint.  
* **S3 Bucket**: Use for storing static assets, configuration files, or backups. \

**modules/s3/main.tf**

```hcl
resource "aws_s3_bucket" "appbucket" {
  bucket = var.bucket_name
  tags = {
    Name = "bhavin-app-s3-bucket"
  }

}
output "app-s3_bucket_name" {
    value = aws_s3_bucket.appbucket.bucket
}
output "app-s3_bucket_id" {
    value = aws_s3_bucket.appbucket.id
}
```

**modules/s3/variable.tf**

```hcl
variable "bucket_name" {
   type = string
   default = "bhavin-app-s31"
}
```


* **Terraform Configuration**:  
  * Utilize Terraform variables to parameterize the deployment (e.g., instance type, database name).  

- create main.tf in root module directory.
```
.
├── backend.tf
├── main.tf
├── modules/
```
**main.tf**
- Basically this main.tf file in root directory is used for define your all modules source to run all modules by this single main.tf file .
- Just like main.yml can run multiple roles.
- if you want to give input at every time , you can define variable in this main.tf file.

```hcl

data "aws_vpc" "custom" {
  id = "vpc-0e1e34491834ecdd5"
}

module "ec2" {
  source                 = "./modules/ec2"
  instance_ami           = "ami-05134c8ef96964280"
  vpc_security_group_ids = [module.security_group.ec2_sg_id]
  instance_type          = "t2.micro"
  instance_tag           = "Bhavin-tf-ec2"

  # vpc_security_group_ids = [module.security_group.ec2-sg.id ]

}
module "security_group" {
  source = "./modules/security_group"
  aws_sg_name = "Bhavin-tf-SG"
  vpc_id = [data.aws_vpc.custom.id]
  
}

module "s3" {
  source = "./modules/s3"
  # bucket_name = var.bucket_name
  
}
```
- If you do not want to touch or modify this main.tf file , you can dynamically manage by **Just enter variable's value** using **terraform.tfvars** file

- For that you have to define variable in main.tf in root directory.
**main.tf**
```hcl

data "aws_vpc" "custom" {
  id = "vpc-0e1e34491834ecdd5"
}

module "ec2" {
  source                 = "./modules/ec2"
  instance_ami           = "ami-05134c8ef96964280"
  vpc_security_group_ids = [module.security_group.ec2_sg_id]
  instance_type          = var.instance_type 
  instance_tag           = var.instance_tag 

  # vpc_security_group_ids = [module.security_group.ec2-sg.id ]

}
module "security_group" {
  source = "./modules/security_group"
  aws_sg_name = var.aws_sg_name
  vpc_id = [data.aws_vpc.custom.id]
  
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  
}
```
**terraform.tfvars**
```hcl
instance_type = "t2.micro"
instance_ami  = "ami-05134c8ef96964280"
bucket_name   = "bhavin-app-s31"
instance_type = "t2.micro"
instance_tag  = "Bhavin-tf-ec2"

```

- To use this terraform.tfvars your all variable should be declared and in the all **modules/variable.tf** files.


  * Use Terraform outputs to display important information (e.g., EC2 public IP, RDS endpoint).  

```hcl
output "ec2_public_ip" {
   value = aws_instance.my-ec2.public_id
}
output "rds_endpoint" {
   value = aws_db_instance.my-rds.endpoint
}
```
  * Implement change sets to demonstrate how Terraform manages infrastructure changes.  
* **No Terraform Modules**: Focus solely on the core Terraform configurations without custom or external modules.

- If you want to configure , whenever you deploy infrastructure your **terraform.tfstate** file should be stored in **S3 Bucket** directly to working with your team like VPC team, SG team, EC2 team, S3 team, RDS team.

- If your **terraform.tfstate** file is exists in only your local, then your team wouldn't be able to work together on microservices.

- You have to setup **BACKEND** as **S3**
- Define **backend.tf** in your root directory.

**backend.tf**

```hcl
terraform {
  backend "s3" {
    bucket = "bhavin-tfstate-s31"
    # bucket = "terraformdemo24"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform_state-lock-bhavin"

  }
}
```

- So, when you run **terraform init**
- It will look for is your backend s3 is setup ?
- If not, then it will run first **backend.tf** and then your all **modules will be runs**.

- To run backend.tf , you have to create 

   - 1. S3 Bucket by terraform -- to stores your terraform.tfstate file
   - 2. dynamodb table -- to stores your LockID.

**dynamodb.tf**

```hcl
provider "aws" {
  region  = "us-west-2"
  profile = "default"
}

resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform_state-lock-bhavin"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table by bhavin"
    }
}
```

**Ensure your terraform.tfstate file is uploaded on s3 backend**

![alt text](p1/s3tfstate.png)

**Ensure your dynamodb table is created and gives your lockid**

![alt text](p1/dynamodb.png)

#### **Key Tasks:**

1. **Setup Terraform Configuration:**  
   * **Provider Configuration**:  
     * Configure the AWS provider to specify the region for deployment.  
     * Ensure the region is parameterized using a Terraform variable.  
   * **VPC and Security Groups**:  
     * Create a VPC with a public subnet for the EC2 instance.  
     * Define security groups allowing HTTP and SSH access to the EC2 instance, and MySQL access to the RDS instance.  
   * **EC2 Instance**:  
     * Define the EC2 instance using a `t2.micro` instance type.  
     * Configure the instance to allow SSH and HTTP access.  
     * Use Terraform variables to define instance parameters like AMI ID and instance type.  
   * **RDS MySQL DB Instance**:  
     * Create a `t3.micro` MySQL DB instance within the same VPC.  
     * Use Terraform variables to define DB parameters like DB name, username, and password.  
     * Ensure the DB instance is publicly accessible, and configure security groups to allow access from the EC2 instance.  
   * **S3 Bucket**:  
     * Create an S3 bucket for storing static files or configurations.  
     * Allow the EC2 instance to access the S3 bucket by assigning the appropriate IAM role and policy.  
   * **Outputs**:  
     * Define Terraform outputs to display the EC2 instance’s public IP address, the RDS instance’s endpoint, and the S3 bucket name.  
2. **Apply and Manage Infrastructure:**  
   * **Initial Deployment**:  
     * Run `terraform init` to initialize the configuration.  
     * Use `terraform plan` to review the infrastructure changes before applying.  
     * Deploy the infrastructure using `terraform apply`, and ensure that the application server, database, and S3 bucket are set up correctly.  
   * **Change Sets**:  
     * Make a minor change in the Terraform configuration, such as modifying an EC2 instance tag or changing an S3 bucket policy.  
     * Use `terraform plan` to generate a change set, showing what will be modified.  
     * Apply the change set using `terraform apply` and observe how Terraform updates the infrastructure without disrupting existing resources.  
3. **Testing and Validation:**  
   * Validate the setup by:  
     * Accessing the EC2 instance via SSH and HTTP.  
     * Connecting to the MySQL DB instance from the EC2 instance.  
     * Verifying that the EC2 instance can read and write to the S3 bucket.  
   * Check the Terraform outputs to ensure they correctly display the relevant information.  
4. **Resource Termination:**  
   * Once the deployment is complete and validated, run `terraform destroy` to tear down all the resources created by Terraform.  
   * Confirm that all AWS resources (EC2 instance, RDS DB, S3 bucket, VPC) are properly deleted.  
5. **Documentation:**  
   * Document the entire process, including Terraform configurations, the purpose of each Terraform file, variables used, and outputs.  
   * Include screenshots or logs demonstrating the deployment, testing, and destruction of the resources.

#### **Deliverables:**

* **Terraform Configuration Files**: All `.tf` files used in the deployment.  
* **Deployment Documentation**: Detailed documentation covering the setup, deployment, change management, and teardown processes.  
* **Test Results**: Evidence of successful deployment and testing, including screenshots or command outputs.  
* **Cleanup Confirmation**: Confirmation that all resources have been terminated using `terraform destroy`.

#### **Estimated Time:**

This project is designed to be completed in **2 hours**.

