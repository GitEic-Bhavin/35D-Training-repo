# provider "aws" {
#   region  = "us-east-2"
#   profile = "training-tf"
# }

# Create S3 Bucker to Manage terraform.tfstate file on Remote location
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