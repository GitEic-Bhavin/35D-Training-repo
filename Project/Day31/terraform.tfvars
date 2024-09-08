# VPC Variable

vpc_cidr = "10.0.0.0/16"
# vpc_name = "${terraform.workspace}-bhavin-vpc"
enable_dns_hostnames = true
enable_dns_support   = true
pub_sub_cidr         = "10.0.16.0/24"
# pub_sub_name = "${terraform.workspace}-Bhavin-Pub-Subnet"

pvt_sub_cidr = "10.0.32.0/24"
# pvt_sub_name = "${terraform.workspace}-Bhavin-Pvt-Subnet"
pvt_sub_cidr2 = "10.0.48.0/24"
# igw_name = "${terraform.workspace}-Bhavin-IGW"
pvt_sub2_name = "Bhavin-pvt-sub-2"
# Public Route Table Name
# pub_rtb_name = "${terraform.workspace}-bhavin-pub_rtb"

# EC2 Variable
ami           = "ami-085f9c64a9b75eed5"
instance_type = "t2.micro"

# ec2_sg_name = "${terraform.workspace}-bhavin-SG"
region = "ap-south-1"

# S3 Variable
bucket_name = "sudarshan-webapp-prod-s3-bucket"
ec2_iam_role_arn     = "arn:aws:iam::339713134976:role/ec2-s3-rds-role"