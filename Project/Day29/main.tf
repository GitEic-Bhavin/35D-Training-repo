
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