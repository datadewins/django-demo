provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "webauto" {
  ami           = var.mail_ami_id
  instance_type = "t2.micro"
  key_name = "mail-sonalis"
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "Web Server"
  }
  }
resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 80
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 80
  }

  ]
}
output "instance_public_ip" {
 description = "Public IP of instance"
 value = aws_instance.webauto.public_ip
}
