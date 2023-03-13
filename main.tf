provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf_public_subnet"
  }
}

resource "aws_subnet" "tf_private_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf_private_subnet"
  }

}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table" "tf_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "tf_rt"
  }
}

resource "aws_route_table_association" "tf_rta" {
  subnet_id      = aws_subnet.tf_public_subnet.id
  route_table_id = aws_route_table.tf_rt.id
}

resource "aws_security_group" "tf_sg" {
  name   = "tf_sg"
  vpc_id = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_sg"
  }
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "tf_instance" {
  ami                    = data.aws_ami.tf_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.tf_public_subnet.id
  vpc_security_group_ids = [aws_security_group.tf_sg.id]
  private_ip             = "10.0.1.100"

  tags = {
    Name = "tf_instance"
  }
}

output "aws_instance_public_ip" {
  value = aws_instance.tf_instance.public_ip
}
