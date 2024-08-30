resource "aws_s3_bucket" "bhavin-s3" {
    bucket = var.s3_bucket_name
    
    tags = {
        Name = var.s3_tag_name
    }
}