terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Change to your preferred region
}

resource "aws_instance" "app_server" {
  ami           = "ami-0735c191cf914754d"  # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  key_name      = "your-key-pair"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app-server"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for main application server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "app_server_ip" {
  value = aws_instance.app_server.public_ip
}

resource "local_file" "app_inventory" {
  content  = templatefile("${path.module}/inventory.tpl",
    {
      app_ip = aws_instance.app_server.public_ip
    }
  )
  filename = "../ansible/inventory.ini"
} 