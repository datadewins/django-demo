provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "webauto" {
most_recent = true
owners = ["self"]

  filter {
    name   = "name"
    values = ["webauto-*"]
  }
}

//Enable to use own ssh key pair
//resource "aws_key_pair" "mykey" {
//  key_name   = "mykey"
//  public_key = "ssh-ed25519 tqzfcXoo mykey"
//}

resource "aws_vpc" "webauto" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "webauto" {
  cidr_block = cidrsubnet(aws_vpc.webauto.cidr_block, 3, 1)
  vpc_id = aws_vpc.webauto.id
  availability_zone = "ap-south-1a"
}

resource "aws_security_group" "webauto" {
name = "webauto"
vpc_id = aws_vpc.webauto.id
// Terraform removes the default rule
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

resource "aws_network_acl" "webauto" {
  vpc_id = aws_vpc.webauto.id
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port   = 22
   }
   ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
   }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    cidr_block = "0.0.0.0/0"
    action     = "allow"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "webauto"
  }
}

resource "aws_instance" "webauto" {
  ami = data.aws_ami.webauto.id
  instance_type = "t2.micro"
  key_name = "webauto"
//  key_name = aws_key_pair.mykey.key_name //Use in case of resource ssh-key pair 
  security_groups = [ aws_security_group.webauto.id ]
  subnet_id = aws_subnet.webauto.id
  associate_public_ip_address = true
  tags = {
    Name = "Web Server Automated"
  }
}

//resource "aws_eip" "webauto" {
//  instance = aws_instance.webauto.id
//  vpc      = true
//}

resource "aws_internet_gateway" "webauto" {
  vpc_id = aws_vpc.webauto.id
}

resource "aws_route_table" "webauto" {
  vpc_id = aws_vpc.webauto.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webauto.id
  }
}
resource "aws_route_table_association" "webauto" {
  subnet_id      = aws_subnet.webauto.id
  route_table_id = aws_route_table.webauto.id
}
output "instance_public_ip" {
 description = "Public IP of instance"
 value = aws_instance.webauto.public_ip
}
