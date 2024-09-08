resource "aws_instance" "my-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "bhavin-${terraform.workspace}.pem"
  
  subnet_id = var.pub_sub_id
  # subnet_id = This will fetch from directory root main.tf module "ec2" block.

  vpc_security_group_ids      = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true
  # vpc_security_group_ids = aws_security_group.pub_sg.id

  tags = {
    Name = "${terraform.workspace}-bhavin-pub-ec2"
  }
  depends_on = [aws_security_group.pub_sg]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx mysql-client",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"

    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.rsa.private_key_pem
      host = self.public_ip
    }
    
  }
}

# Create pem file
resource "aws_key_pair" "tf-key-pair" {
  key_name   = "bhavin-${terraform.workspace}.pem"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "bhavin-${terraform.workspace}.pem"
  file_permission = 0400
}

# Create SG for Public EC2

resource "aws_security_group" "pub_sg" {
  name = var.ec2_sg_name
  # vpc_id = var.vpc_id

  ingress {
    from_port   = var.ingress_ssh.from_port
    to_port     = var.ingress_ssh.to_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    from_port   = var.ingress_http.from_port
    to_port     = var.ingress_http.to_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    from_port   = var.ingress_https.from_port
    to_port     = var.ingress_https.to_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    from_port   = var.ingress_icmp.from_port
    to_port     = var.ingress_icmp.to_port
    protocol    = "icmp"
    cidr_blocks = var.cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# output "sg_id" {
#   value = aws_security_group.pub_sg.id
# }