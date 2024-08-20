Day 28 		Terraform

```hcl
terraform {
	required_providers {
		aws = {
			source = “hashicorp/aws”
			version = “~>4.16”
		}
	}
	required_version = “>=1.2.0”
	
provider “aws” {
	region = “us-east-2”
}

resource “aws_instance” “app_server” {
	ami			= “ami-8302084”
	instance_type	= “t2.micro”
  
	tags = {
		Name = “Bhavin-Instance”
	}
}
```

**terraform init** –It will download the provider if not exists in local.
**terraform fmt** – It will Formate main.tf file for indentations.
**terraform validate** – Validate Suntax error.
**terraform plan** – Show whatever rasources will be deployed.
**terraform apply** – Deploy the actual Resources in real time. 	
**terraform destroy** – Destory all the resouces which are present in stack file.
**terraform show** – Show terraform.tfstate file

terraform.tfstate file has all details about whatever you deployed resources, that resources’s attributes like ex. Instace, Instance name, id , vpc, Security Group, Tags, Key-pair etc.

Whenever you make changes in configuration file main.tf, this changes will catch up by statefile. Bcz, state file will check new updates using current state of state file and main.tf file. If any changes is happens it will create, update or delete resources.

If you try to redeploy same resources, it will not deploy resources. Bcz, current state file has no updates, changes.	


Variable to avoid hardcoded values.

1. variable.tf
```hcl
variable “instance_name” {
	description = “Instance will for frontend”
	type = String
	default = “NewAppServer”
}

variabel “instance_type” {
	type = string
	default = “t2.micro”
}
```

main.tf
```hcl
resource “aws_instance” “app_server” {
	ami			= “ami-8302084”
	instance_type	= var.instance_type
  
	tags = {
		Name = var.instance_name
	}
```

#### Run Time Pass Arguments
```hcl
terraform plan --var-file=/home/einfochips/35Day-Training/variable.tf
```

```hcl
terraform plan --var “variable_name in variable.tf=new_value instead of old value of this variable”
terraform plan --var “instance_type=t2.small”
```

OutPut Block

Use output.tf or main.tf

```hcl
output “instance_id” {
	description 		= “ID of the Instance”
	value	 		= “aws_instnace.app_server”
}
output “instance_public_ip” {
	ami 		= “ami-80u30”
	value 		= aws_instance.app_server.public_ip
}
```
