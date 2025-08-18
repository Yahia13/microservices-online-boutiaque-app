#----VPC creation---
resource "aws_vpc" "vpc_eks_main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags={
    Name= "Main-vpc"
  }
}
#-----subnet creattion----

#private-subnet- AZ 1a(worknodes)
resource "aws_subnet" "private_subnet_1a" {
   vpc_id = aws_vpc.vpc_eks_main.id
   cidr_block = "10.0.1.0/24"
   availability_zone = "eu-central-1a"
   tags = {
     Name=" private-subnet-a"
     "kubernetes.io/role/internal-elb"="1"
   }
}

#private-subnet- AZ 1b(worknodes)

resource "aws_subnet" "private_subnet_1b" {
   vpc_id = aws_vpc.vpc_eks_main.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "eu-central-1b"
   tags = {
     Name=" private-subnet-b"
     "kubernetes.io/role/internal-elb"="1"
   }
}

#public-subnet- AZ 1a(loadbalancers)

resource "aws_subnet" "public_subnet_1a" {
   vpc_id = aws_vpc.vpc_eks_main.id
   cidr_block = "10.0.3.0/24"
   availability_zone = "eu-central-1a"
   tags = {
     Name=" public-subnet-a"
     "kubernetes.io/role/elb"="1"
   }
}
#public-subnet- AZ 1b(loadbalencers)
resource "aws_subnet" "public_subnet_1b" {
   vpc_id = aws_vpc.vpc_eks_main.id
   cidr_block = "10.0.4.0/24"
   availability_zone = "eu-central-1b"
   tags = {
     Name=" public-subnet-b"
     "kubernetes.io/role/elb"="1"
   }
}

#internet-gw----

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_eks_main.id
  tags = {
    Name = "Main-igw"
  }
}

#Elastique ips for private nat gw---
resource "aws_eip" "nat_eip1a_for_gw" {
  tags = {Name="eip-nat-1a"}
}
resource "aws_eip" "nat_eip1b_for_gw" {
  tags = {Name="eip-nat-1b"}
}
#NAT gateway---

resource "aws_nat_gateway" "NAT_gw_public1a" {
  allocation_id = aws_eip.nat_eip1a_for_gw.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  tags = {
    Name = "gw-NAT-1a"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "NAT_gw_public1b" {
  allocation_id = aws_eip.nat_eip1b_for_gw
  subnet_id     = aws_subnet.public_subnet_1b.id

  tags = {
    Name = "gw-NAT-1b"
  }

  depends_on = [aws_internet_gateway.igw]
}


