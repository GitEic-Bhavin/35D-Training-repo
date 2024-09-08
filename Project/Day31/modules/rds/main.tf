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
  vpc_security_group_ids    = [aws_security_group.bhavin-rds-sg.id]

  tags = {
    Name = "Bhavin-rds"
    owner = "bhavin.bhavsar@einfochips.com"
    DM = "Sachin Koshti"
    Department = "PES"
    End_Date = "5 Sep 2024"
  }
  

}

# Create RDS SG 
resource "aws_security_group" "bhavin-rds-sg" {
  name = "${terraform.workspace}-bhavin-rds-SG"

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [var.pub_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${terraform.workspace}-bhavin-rds-SG"
    owner = "bhavin.bhavsar@einfochips.com"
    DM = "Sachin Koshti"
    Department = "PES"
    End_Date = "5 Sep 2024"
  }
}

# Create RDS Subnet Groups to deploy rds instance
resource "aws_db_subnet_group" "myrds-sub-grp" {
  name = "bhavin-rds-pvt-sub"

  subnet_ids = var.subnet_ids

  tags = {
    Name = "${terraform.workspace}-bhavin-rds-SG"
    owner = "bhavin.bhavsar@einfochips.com"
    DM = "Sachin Koshti"
    Department = "PES"
    End_Date = "5 Sep 2024"
  }

}