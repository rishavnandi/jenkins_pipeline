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

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0735c191cf914754d"  # Ubuntu 20.04 LTS
  instance_type = "t2.medium"
  key_name      = "your-key-pair"

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "jenkins-server"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Security group for Jenkins server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# Output the Jenkins server IP to be used in Ansible
output "jenkins_ip" {
  value = aws_instance.jenkins_server.public_ip
}

# Create a local file with Jenkins IP for Ansible
resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/inventory.tpl",
    {
      jenkins_ip = aws_instance.jenkins_server.public_ip
    }
  )
  filename = "../ansible/inventory.ini"
} 