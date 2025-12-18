resource "aws_vpc" "devops_project" {
  cidr_block       = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.common_tag
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.devops_project.id
  cidr_block = var.public_subnet_1
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a" 

  tags = {
    Name = var.common_tag
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.devops_project.id
  cidr_block = var.public_subnet_2
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.common_tag
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.devops_project.id
  cidr_block = var.private_subnet_1
  availability_zone = "ap-south-1a"

  tags = {
    Name = var.common_tag
    "kubernetes.io/cluster/${var.cluster_name}"      = "shared"
    "kubernetes.io/role/internal-elb"                = "1"
  }
}


resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.devops_project.id
  cidr_block = var.private_subnet_2
  availability_zone = "ap-south-1b"

  tags = {
    Name = var.common_tag
    "kubernetes.io/cluster/${var.cluster_name}"      = "shared"
    "kubernetes.io/role/internal-elb"                = "1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_project.id

  tags = {
    Name = "devops_project"
  }
}

resource "aws_route_table" "public_subnet_routetable" {
  vpc_id = aws_vpc.devops_project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "devops_project"
  }
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_routetable.id
}

resource "aws_route_table_association" "public_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_routetable.id
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        Name = "devops_project"
    }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name       = "de_nat"
    Department = "DevOps infra"
  }
}

resource "aws_route_table" "private_subnet_routetable" {
  vpc_id = aws_vpc.devops_project.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "devops_project"
  }
}
resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet_routetable.id
}

resource "aws_route_table_association" "private_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet_routetable.id
}