# provider "aws" {
#     region = "us-east-2"
#     profile = "training-tf"
# }

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
