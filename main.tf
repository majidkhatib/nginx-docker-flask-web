provider "aws" {
  region     = "eu-central-1"
  access_key = "AKIA2MNBP5IR4SCNYRPX"
  secret_key = "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"
}

resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "to allow my web to be accesible and I be able to ssh to the server"

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
    Name = "allow_web_access"
  }
}


resource "aws_instance" "webserver" {
    ami = "ami-0f61af304b14f15fb"
    instance_type = "t2.micro"
    key_name = "EC2-Web-Server"
    security_groups =  ["allow_web_traffic"]

    tags = {
        Name = "WebServer01"
    }
}

resource "aws_ecr_repository" "majidshahidi" {
  name                 = "docker-flask-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
