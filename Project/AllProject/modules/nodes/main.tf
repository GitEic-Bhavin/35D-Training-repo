data "aws_vpc" "default" {
    id = "vpc-05c614e04b16b60c7"
}

# To use My IP as CIDR block
data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}


resource "aws_instance" "master" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.master_sg.id]
    # subnet_id = var.pub_sub_id
  
    key_name = "bhavin-tf-key-${terraform.workspace}"

    tags = {
        Name = var.master_node_name
    }

}
resource "aws_security_group" "master_sg" {
    name = var.master_sg_name
    vpc_id = data.aws_vpc.default.id
    # subnet_id     = var.pub_sub_id

    ingress {
        from_port = var.ssh.from_port
        to_port = var.ssh.to_port
        protocol = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]

    }
    ingress {
        from_port = var.http.from_port
        to_port = var.http.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.https.from_port
        to_port = var.https.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

# Allow ports for Master Node
    ingress {
        from_port = var.api_server.from_port
        to_port = var.api_server.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.etcd.from_port
        to_port = var.etcd.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.kubelet.from_port
        to_port = var.kubelet.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.schedular.from_port
        to_port = var.schedular.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.controller.from_port
        to_port = var.controller.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

# OutBound Rule
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.cidr_blocks
    }
  
}

# Generate SSH Key
resource "aws_key_pair" "tf-key-pair" {
    key_name = "bhavin-tf-key-${terraform.workspace}"
    public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
}
resource "local_file" "tf-key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "bhavin-tf-key-${terraform.workspace}.pem"
    file_permission = 0400
}

# Create 2 Worker Node
resource "aws_instance" "worker" {
    count = length(var.worker_node_name)
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.worker_sg.id]

    key_name = "bhavin-tf-key-${terraform.workspace}"

    tags = {
        Name = var.worker_node_name[count.index]
    }
}

# Create SG for Worker Node

resource "aws_security_group" "worker_sg" {
    name = var.worker_sg_name
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = var.ssh.from_port
        to_port = var.ssh.to_port
        protocol = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]

    }
    ingress {
        from_port = var.http.from_port
        to_port = var.http.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.https.from_port
        to_port = var.https.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

# Allow worker Node ports
   ingress {
        from_port = var.api_server.from_port
        to_port = var.api_server.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.kubelet.from_port
        to_port = var.kubelet.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.nodeport.from_port
        to_port = var.nodeport.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }

# Create OutBound Rule
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.cidr_blocks
    }

}