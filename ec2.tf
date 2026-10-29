resource "aws_instance" "test_ec2" {
  ami                         = "ami-022374b883d9d7931"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.test_subnet.id
  key_name                    = aws_key_pair.key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "test-server"
  }
}

