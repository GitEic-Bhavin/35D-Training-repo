variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "master_sg_name" {
  type = string
}

variable "ssh" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 22
      to_port = 22
    }

}

variable "cidr_blocks" {
    default = ["0.0.0.0/0"]
  
}

variable "http" {
    type = object({
      from_port = number
      to_port = number
    }) 
    default = {
      from_port = 80
      to_port = 80
    }
}

variable "https" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 443
      to_port = 443
    }
}

# Master Node allow ports

variable "api_server" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 6443
      to_port = 6443
    }
  
}
variable "etcd" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 2379
      to_port = 2380
    }
  
}
variable "kubelet" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 10250
      to_port = 10250
    }
}
variable "schedular" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 10259
      to_port = 10259
    }
  
}
variable "controller" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 10257
      to_port = 10257
    }
  
}

# Give Master Node Name
variable "master_node_name" {
    type = string 
}

# worker node
variable "worker_node_name" {
    type = list(string)

}
variable "worker_sg_name" {
    type = string
}

# worker node sg
variable "nodeport" {
    type = object({
      from_port = number
      to_port = number
    })
    default = {
      from_port = 30000
      to_port = 32767
    }
  
}