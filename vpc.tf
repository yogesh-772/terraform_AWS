provider "aws" {
  region                   = "ap-south-1"
  shared_credentials_files = ["~/.aws/credentials"]
}
resource"aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "test_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
}
resource "aws_internet_gateway" "test_gateway" {
  vpc_id = aws_vpc.test_vpc.id
}
resource "aws_route_table" "test_route" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }
}
resource "aws_route_table_association" "test_association" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_route.id
}
resource "aws_security_group" "test_sg" {
  name        = "my_sg"
  vpc_id      = aws_vpc.test_vpc.id
  description = "shh,HTTP,HTTPS"
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
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "local_file" "priv_key" {
    filename = "web-key.pem"
    content = tls_private_key.key.private_key_pem
}
resource "aws_key_pair" "key_pair" {
  key_name = "web_key"
  public_key = tls_private_key.key.public_key_openssh
}
