provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = "${terraform.workspace}-bhavin-vpc"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  pub_sub_cidr         = var.pub_sub_cidr
  pub_sub_name         = "${terraform.workspace}-Bhavin-Pub-Subnet"
  # vpc_id = module.vpc.vpc_id to directly fetch output of vpc_id and use into module vpc.

  pvt_sub_cidr = var.pvt_sub_cidr
  pvt_sub_name = "${terraform.workspace}-Bhavin-Pvt-Subnet"
  pvt_sub_cidr2 = var.pvt_sub_cidr2
  pvt_sub2_name = var.pvt_sub2_name


  # IGW Variable
  igw_name = "${terraform.workspace}-Bhavin-IGW"

  # Public rtb name
  pub_rtb_name = "${terraform.workspace}-bhavin-pub_rtb"
  pvt_rtb_name = "${terraform.workspace}-bhavin-pvt-rtb"
  # subnet_id = var.subnet_id

  #   output "pvt-sub-id" {
  #     value = module.vpc.pvt-sub-id
  #   }
}

module "ec2" {
  source = "./modules/ec2"

  # EC2 Vars
  ami           = var.ami
  instance_type = var.instance_type
  pub_sub_id    = module.vpc.pub_sub_id
  # subnet_ids = [module.vpc.pvt-sub-id]
  ec2_sg_name = "${terraform.workspace}-bhavin-SG"


}

# RDS Variables
module "rds" {
  source     = "./modules/rds"
  subnet_ids = [module.vpc.pvt_sub_id, module.vpc.pvt_sub2_id]
  pub_sg_id = module.ec2.pub_sg_id

}

# IAM 
module "iam" {
  source = "./modules/IAM"
  
}

# S3
module "s3" {
  source           = "./modules/s3"
  bucket_name      = var.bucket_name
  environment      = var.environment
  ec2_iam_role_arn = var.ec2_iam_role_arn
}