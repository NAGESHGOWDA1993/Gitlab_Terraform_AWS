#creating a VPC
resource "aws_vpc" "lab-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lab_vpc"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "lab-Gateway" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "Nagesh-Internet-Gateway"
  }
}

#creating elastic IP address
resource "aws_eip" "lab-Elastic-IP" {
  vpc = true
}

#creating NAT gateway
resource "aws_nat_gateway" "lab-NAT-Gateway" {
  allocation_id = aws_eip.lab-Elastic-IP.id
  subnet_id     = aws_subnet.public-subnet.id
}

#creating NAT route
resource "aws_route_table" "lab-Route-two" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab-NAT-Gateway.id
  }

  tags = {
    Name = "Nagesh-lab-Network-Address-Route"
  }
}

#creating public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.lab-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "nagesh-public-subnet"
  }
}

#creating private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.lab-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "nagesh-private-subnet"
  }
}

#creating route table association
resource "aws_route_table_association" "lab-Route-two" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.lab-Route-two.id
}

#creating route table
resource "aws_route_table" "Nagesh-Web-Tier" {
  tags = {
    Name = "Nagesh-Web-Tier"
  }
  vpc_id = aws_vpc.lab-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-Gateway.id
  }
}

#creating route table association
resource "aws_route_table_association" "lab-web-tier1" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.Nagesh-Web-Tier.id
}

#creating public security group
resource "aws_security_group" "lab-Public-SG" {
  name        = "lab-Public-SG"
  description = "web and SSH allowed"
  vpc_id      = aws_vpc.lab-vpc.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
