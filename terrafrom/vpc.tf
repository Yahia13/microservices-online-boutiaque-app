#----VPC creation---
resource "aws_vpc" "vpc-eks-main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags={
    Name= "Main-vpc"
  }
}
#-----subnet creattion----

#private-subnet- AZ 1a(worknodes)
resource "aws_subnet" "1st-private-subnet" {
   vpc_id = aws_vpc.vpc-eks-main.id
   cidr_block = "10.0.1.0/24"
   availability_zone = "eu-central-1a"
   tags = {
     Name=" private-subnet-a"
     "kubernetes.io/role/internal-elb"="1"
   }
}

#private-subnet- AZ 1b(worknodes)

resource "aws_subnet" "2nd-private-subnet" {
   vpc_id = aws_vpc.vpc-eks-main.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "eu-central-1b"
   tags = {
     Name=" private-subnet-b"
     "kubernetes.io/role/internal-elb"="1"
   }
}

#public-subnet- AZ 1a(loadbalancers)

resource "aws_subnet" "1st-public-subnet" {
   vpc_id = aws_vpc.vpc-eks-main.id
   cidr_block = "10.0.3.0/24"
   availability_zone = "eu-central-1a"
   tags = {
     Name=" public-subnet-a"
     "kubernetes.io/role/elb"="1"
   }
}
#public-subnet- AZ 1b(loadbalencers)
resource "aws_subnet" "2nd-public-subnet" {
   vpc_id = aws_vpc.vpc-eks-main.id
   cidr_block = "10.0.4.0/24"
   availability_zone = "eu-central-1b"
   tags = {
     Name=" public-subnet-b"
     "kubernetes.io/role/elb"="1"
   }
}

#internet-gw----

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-eks-main.id
  tags = {
    Name = "Main-igw"
  }
}



