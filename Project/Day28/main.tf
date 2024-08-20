resource "aws_instance" "app_server" {
  instance_type = var.instance_type
  ami           = var.instance_ami
  iam_instance_profile = "EC2-S3-Role"
  vpc_security_group_ids = [aws_security_group.bhavin-sg.id]

  tags = {
    Name = var.instance_tag
  }

  depends_on = [aws_security_group.bhavin-sg]

  key_name = "ansible-worker"
}

resource "aws_security_group" "bhavin-sg" {
  name = var.aws_sg_name
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
       }
}


resource "aws_db_instance" "bhavin-rds" {
  allocated_storage         = var.allocate_storage
  db_name                   = var.db_name
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  username                  = var.username
  password                  = var.password
  parameter_group_name      = var.parameter_group_name
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifie
  vpc_security_group_ids = [aws_security_group.bhavin-rds-sg.id]
  
  tags = {
    Name = "Bhavin-rds"
  }
  publicly_accessible = true
  # To make RDS as public while you launch it from terraform.

  depends_on = [aws_security_group.bhavin-rds-sg]

}
resource "aws_security_group" "bhavin-rds-sg" {
  name = var.aws_rds_sg_name

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks = [ aws_security_group.bhavin-sg.id ]
    security_groups = [ aws_security_group.bhavin-sg.id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create S3 Bucket and upload image as object

resource "aws_s3_bucket" "bhavin-s3" {
  bucket = "bhavin-s3-tf"
  tags = {
    Name = "bhavin-s3-bucket"
  }

}

resource "aws_s3_bucket_public_access_block" "make_public" {
  bucket = aws_s3_bucket.bhavin-s3.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_object" "shiva_jpg" {
  content = var.s3_object_upload
  key     = var.s3_object_name
  bucket  = aws_s3_bucket.bhavin-s3.id

}