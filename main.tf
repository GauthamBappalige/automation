
# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  

  tags = {
    Name = "gautham"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "gauthamIGW"
  }
}


# Create public subnets
resource "aws_subnet" "public_subnet" {
  count                  = 3
  vpc_id                 = aws_vpc.my_vpc.id
  cidr_block             = "10.0.${count.index}.0/24"  
  availability_zone      = "us-east-1a"  

  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet" {
  count                  = 3
  vpc_id                 = aws_vpc.my_vpc.id
  cidr_block             = "10.0.${count.index + 10}.0/24"  
  availability_zone      = "us-east-1b"  

  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "gauthamroute"
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  count                  = 3
  subnet_id              = aws_subnet.public_subnet[count.index].id
  route_table_id         = aws_route_table.routetable.id
}