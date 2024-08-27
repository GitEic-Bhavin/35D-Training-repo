# Use Existing Default vpc

# data "aws_vpc" "default" {
#     id = "vpc-08c06cdab0e2400dc"
# }

resource "aws_vpc" "ecs" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }

}

resource "aws_subnet" "public" {
    vpc_id =  aws_vpc.ecs.id
    cidr_block = var.public_subnet_cidr
    availability_zone = "us-west-2a"

    tags = {
      Name = "${terraform.workspace}-Bhavin-Pub-Subnet"
    }
}
resource "aws_subnet" "pvt1" {
    vpc_id = aws_vpc.ecs.id
    cidr_block = var.pvt_subnet_cidr1
    availability_zone = "us-west-2b"

    tags = {
        Name = "${terraform.workspace}-Bhavin-Pvt-Subnet1"
    }
  
}

resource "aws_subnet" "pvt2" {
    vpc_id = aws_vpc.ecs.id
    cidr_block = var.pvt_subnet_cidr2
    availability_zone = "us-west-2a"

    tags = {
        Name = "${terraform.workspace}-Bhavin-Pvt-Subnet2"
    }

}

# Create SG
resource "aws_security_group" "pub-sg" {
    vpc_id = aws_vpc.ecs.id

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create SG for RDS

resource "aws_security_group" "bhavin-rds-sg" {
  name = "${terraform.workspace}-bhavin-rds-SG"
  vpc_id = aws_vpc.ecs.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.pub-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "back-sg" {
    vpc_id = aws_vpc.ecs.id

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [aws_security_group.pub-sg.id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.ecs.id

    tags = {
      Name = "Bhavin-Igw"
    }
}

resource "aws_route_table" "pub" {
    vpc_id = aws_vpc.ecs.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myigw.id
    }

    tags = {
      Name = "bhavin-rtb-pub"
    }
}


resource "aws_route_table_association" "pub-rtb" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.pub.id
}


# Create NAT Gateway for my private subnet my ecs container can pull image form docker hub

resource "aws_eip" "nat" {
  tags = {
    Name = "bhavin-natgatway-eip"
  }
  
}

resource "aws_nat_gateway" "myngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "bhavin-ngw"
  }
  
}
resource "aws_route_table" "pvt" {
    vpc_id = aws_vpc.ecs.id

    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.myngw.id
    }
    
    tags = {
      Name = "Bhavin-pvt-rtb"
    }
}

resource "aws_route_table_association" "pvt1" {
  subnet_id = aws_subnet.pvt1.id
  route_table_id = aws_route_table.pvt.id
  
}

resource "aws_route_table_association" "pvt2" {
  subnet_id = aws_subnet.pvt2.id
  route_table_id = aws_route_table.pvt.id
  
}

# Create ecs cluster

resource "aws_ecs_cluster" "pub-cluster" {
  name = "bhavin-ecs-cluster-pub"
  
}
resource "aws_ecs_task_definition" "pub-task" {
  family = "frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name = "bhavin-frontend-container"
      image = "bhavin1099/day9nginx:v1"
      cpu = 256
      memory = 512
      essential = true
      protMappings = [
        {
          containerPort = 80
          hostport = 81
          protocol = "tcp"
        }
      ]
    }
  ])
    execution_role_arn = data.aws_iam_role.existing_role.arn
}

data "aws_iam_role" "existing_role" {
  name = "ecsTaskRole"
}

resource "aws_ecs_task_definition" "pvt-task" {
    family = "backend"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"

    container_definitions = jsonencode([
      {
        name = "bhavin-backend-container"
        image = "bhavin1099/nodejs-nginx"
        cpu = 256
        memory = 512
        essential = true
        protMappings = [
          {
            containerPort = 80
            hostPort = 82
          }
        ]
        environment = [ 
          {
            name = "DATABASE_URL"
            value = aws_db_instance.myrdsdb.endpoint
          },
          {
            name = "DB_PASSWORD"
            value = var.DB_PASSWORD
          }
        ]

      }
    ])
}
output "DATABASE_URL" {
  value = aws_db_instance.myrdsdb.endpoint
  sensitive = true
}
# Create ECS Service

resource "aws_ecs_service" "front" {
  name = "frontend-service"
  cluster = aws_ecs_cluster.pub-cluster.id
  task_definition = aws_ecs_task_definition.pub-task.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.public.id]
    security_groups = [aws_security_group.pub-sg.id]
    assign_public_ip = true
  }
  
}

resource "aws_ecs_service" "back" {
  name = "backend-service"
  cluster = aws_ecs_cluster.pub-cluster.id
  task_definition = aws_ecs_task_definition.pvt-task.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.pvt1.id, aws_subnet.pvt2.id]
    security_groups = [aws_security_group.back-sg.id]
    assign_public_ip = false # Bydefault this is false
  }
  
}

# Setup RDS

resource "aws_db_subnet_group" "mydb-subnet" {
  name = "bhavin-db-sunet-group"
  subnet_ids = [aws_subnet.pvt1.id, aws_subnet.pvt2.id]

  
}

resource "aws_db_instance" "myrdsdb" {

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
  db_subnet_group_name = aws_db_subnet_group.mydb-subnet.name

  tags = {
    Name = "Bhavin-rds"
  }

  
}