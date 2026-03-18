# Create VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Create internet gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks_igw"
  }
}



# Create public subnets
resource "aws_subnet" "eks_public_subnet" {
  count = var.subnet_counts
  vpc_id = aws_vpc.eks_vpc.id
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "eks_public_subnet_${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "eks_private_subnet" {
  count = var.subnet_counts
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "eks_private_subnet_${count.index}"
  }
}


# Create NAT gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "eks_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.eks_public_subnet[0].id
}

# Create private route table
resource "aws_route_table" "eks_priv_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gw.id
  }
  tags = {
    Name = "eks_priv_rt"
  }
}

# Create public route table
resource "aws_route_table" "eks_pub_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  tags = {
    Name = "eks_pub-rt"
  }
}

# Create public subnet association with route table
resource "aws_route_table_association" "eks_rt_asc_pub" {
  count = length(aws_subnet.eks_public_subnet)
  route_table_id = aws_route_table.eks_pub_rt.id
  subnet_id = aws_subnet.eks_public_subnet[count.index].id
}

# Create private subnet association with route table
resource "aws_route_table_association" "eks_rt_asc_priv" {
  count = length(aws_subnet.eks_private_subnet)
  route_table_id = aws_route_table.eks_priv_rt.id
  subnet_id = aws_subnet.eks_private_subnet[count.index].id
}



