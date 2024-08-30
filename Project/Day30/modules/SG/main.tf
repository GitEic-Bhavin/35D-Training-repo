resource "aws_security_group" "sg" {
    name = var.ec2_sg_name

    ingress {
        from_port = var.ingress_ssh.from_port
        to_port = var.ingress_ssh.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.ingress_http.from_port
        to_port = var.ingress_http.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.ingress_https.from_port
        to_port = var.ingress_https.to_port
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    ingress {
        from_port = var.ingress_icmp.from_port
        to_port = var.ingress_icmp.to_port
        protocol = "icmp"
        cidr_blocks = var.cidr_blocks
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
