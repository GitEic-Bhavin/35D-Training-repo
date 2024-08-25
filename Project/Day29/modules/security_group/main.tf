# Create Security Group by Module

resource "aws_security_group" "ec2-sg" {
    name = var.aws_sg_name
    vpc_id = "vpc-0e1e34491834ecdd5"

    ingress {
        from_port = var.ingress_ssh.from_port
        to_port = var.ingress_ssh.to_port
        protocol = var.ingress_ssh.protocol
        cidr_blocks = var.ingress_ssh.cidr_blocks
    }
    ingress {
        from_port = var.ingress_http.from_port
        to_port = var.ingress_http.to_port
        protocol = var.ingress_http.protocol
        cidr_blocks = var.ingress_http.cidr_blocks
    }
    ingress {
        from_port = var.ingress_https.from_port
        to_port = var.ingress_https.to_port
        protocol = var.ingress_http.protocol
        cidr_blocks = var.ingress_https.cidr_blocks
    }
    # ingress {
    #     from_port = var.ingress_icmp.from_port
    #     to_port = var.ingress_icmp.to_port
    #     protocol = var.ingress_http.protocol
    #     cidr_blocks = var.ingress_icmp.cidr_blocks
    # }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
output "ec2_sg_id" {
    value = aws_security_group.ec2-sg.id 
}
output "sg_name" {
    value = aws_security_group.ec2-sg.name_prefix
}