#----VPC creation---
resource "aws_vpc" "vpc-eks-main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags={
    Name= "Main-vpc"
  }
}
resource "aws_subnet" "1st-private-subnet" {
   vpc_id = aws_vpc.vpc-eks-main
   cidr_block = "10.0.1.0/24"
   availability_zone = "eu-central-1a"
   tags = {
     Name=" private-subnet-a"
     "kubernetes.io/role/elb"="1"
   }
}