provider "aws" {
  region     = "eu-west-1"
}

# Defined some variable


variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "webserver01"
}


# Code Section


resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "to allow my web to be accesible and I be able to ssh to the server "

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}



resource "aws_instance" "webserver" {
    ami = "ami-0069d66985b09d219"
    instance_type = "t2.micro"
    key_name = "EC2Instance-Irelan"
    security_groups =  ["allow_web_traffic"]

    /* This Section can be added if the ECR already exist
    user_data = <<-EOF
                #!bin/bash
                sudo yum update
                sudo yum install -y 
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                sudo yum install docker-ce docker-ce-cli containerd.io
                aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 713840126499.dkr.ecr.eu-west-1.amazonaws.com
                docker pull 713840126499.dkr.ecr.eu-central-1.amazonaws.com/docker-flask-nginx:v1.6
                docker run -d -p 80:80 713840126499.dkr.ecr.eu-central-1.amazonaws.com/docker-flask-nginx:v1.6
                EOF
    */

    tags = {
        Name = var.instance_name
    }
}


resource "aws_ecr_repository" "docker-flask-nginx" {
  name                 = "docker-flask-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# To print the public IP of the Instance after creation


output "instance_ip_addr" {
  value = aws_instance.webserver.private_ip
}
