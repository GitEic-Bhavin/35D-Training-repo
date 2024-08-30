provider "aws" {
  region = "us-east-2"
}

module "ec2" {
    source = "./modules/ec2"
    vpc_security_group_ids = [module.SG.sg_id]
    ami = "ami-085f9c64a9b75eed5"
    instance_type = var.instance_type
    aws_profile = "default"

}

variable "instance_type" {
  
}

module "SG" {
    source = "./modules/SG"
    ec2_sg_name = "bhavin-${terraform.workspace}"
    # ingress_http = ""
    # ingress_https = ""
    # ingress_icmp = ""
}
module "S3" {
    source = "./modules/S3"
    s3_bucket_name = "bhavin-s3-${terraform.workspace}"

    # bucket_name = var.s3_bucket_name
}