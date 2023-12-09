# AWS Resources

# AWS VPC
resource "aws_vpc" "food-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "food-vpc"
  }
}

# AWS Subnet
resource "aws_subnet" "food-subnet" {
  vpc_id     = aws_vpc.food-vpc.id
  cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = "true"
availability_zone = "ap-south-1b"
  tags = {
    Name = "food-subnet"
  }
}

# AWS Internet Gateway
resource "aws_internet_gateway" "food-igw" {
  vpc_id = aws_vpc.food-vpc.id

  tags = {
    Name = "food-gateway"
  }
}

# AWS Route Table
resource "aws_route_table" "food-rt" {
  vpc_id = aws_vpc.food-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.food-igw.id
  }

  tags = {
    Name = "food-route-table"
  }
}

# AWS Route Table Subnet Accociation
resource "aws_route_table_association" "food-rt-sn" {
  subnet_id      = aws_subnet.food-subnet.id
  route_table_id = aws_route_table.food-rt.id
}

# AWS Secirity Group
resource "aws_security_group" "food-sg" {
  name        = "food-sg"
  description = "Allow SSH - HTTP inbound traffic"
  vpc_id      = aws_vpc.food-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "food-sg"
  }
}

# AWS EC2 Instannce
resource "aws_instance" "food-ec2" {
  ami           = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.medium"
  key_name = "karthik"
  subnet_id = aws_subnet.food-subnet.id
  vpc_security_group_ids = [aws_security_group.food-sg.id]
  user_data = file("food.sh")

  tags = {
    Name = "food"
  }
}


