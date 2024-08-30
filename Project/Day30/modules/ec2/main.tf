provider "aws" {
    region = "ap-south-1"
    profile = var.aws_profile
  
}

resource "aws_instance" "bhavin-instance" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = var.vpc_security_group_ids

    key_name = "bhavin-tf-key-${terraform.workspace}"

    tags = {
        Name = "${terraform.workspace}-bhavin-ec2"
    }


# Install apache2 after instance launched succesfully.
    provisioner "remote-exec" {
        inline = [ 
            "sudo apt-get update -y",
            "sudo apt-get install -y apache2",
            "sudo systemctl start apache2",
            "sudo systemctl enable apache2"
        ]
    # Connect to ec2 via ssh by connection block by terraform
    connection {
      type = "ssh"
      user = "ubuntu"
    #   private_key = file("bhavin-tf-key.pem")
      host = self.public_ip
    #   private_key = tls_private_key.rsa.private_key_pem
      private_key = file(local_file.tf-key.filename)
        }
    }
    depends_on = [ aws_key_pair.tf-key-pair ]

    provisioner "local-exec" {
        command = <<EOT
        chmod 400 'bhavin-tf-key.pem',
        echo "EC2 is deployed with installed Apache2",
        echo "See Instance Public IP is ${self.public_ip}"
        EOT
      
    }
}

# Create SSH private key file and use it for ssh by terraform

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
}
