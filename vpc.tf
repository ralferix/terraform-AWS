# vpc.tf 
# Create VPC/Subnet/Security Group/ACL
# create the VPC
resource "aws_vpc" "tap" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}" 
  enable_dns_support   = "${var.dnsSupport}" 
  enable_dns_hostnames = "${var.dnsHostNames}"
} 
# end resource
# create the Subnet
resource "aws_subnet" "tap_Subnet" {
  vpc_id                  = "${aws_vpc.tap.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}" 
  availability_zone       = "${var.availabilityZone}"
tags = {
   Name = "My VPC Subnet"
  }
} 
# end resource
# Create the Security Group
resource "aws_security_group" "tap_Security_Group" {
  vpc_id       = "${aws_vpc.tap.id}"
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
ingress {
    cidr_blocks = "${var.ingressCIDRblock}"  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
tags = {
     Name = "My VPC Security Group"
  }
} # end resource
# create VPC Network access control list
resource "aws_network_acl" "tap_Security_ACL" {
  vpc_id = "${aws_vpc.tap.id}"
  subnet_ids = [ "${aws_subnet.tap_Subnet.id}" ]
# allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}" 
    from_port  = 22
    to_port    = 22
  }
# allow ingress http
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 80
    to_port    = 80
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 1024
    to_port    = 65535
  }
} 
# end resource
# Create the Internet Gateway
resource "aws_internet_gateway" "tap_GW" {
  vpc_id = "${aws_vpc.tap.id}"
} 

# Create the Route Table
resource "aws_route_table" "tap_route_table" {
    vpc_id = "${aws_vpc.tap.id}"
} 
# end resource
# Create the Internet Access
resource "aws_route" "tap_internet_access" {
  route_table_id        = "${aws_route_table.tap_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.tap_GW.id}"
} 
# end resource
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "tap_association" {
    subnet_id      = "${aws_subnet.tap_Subnet.id}"
    route_table_id = "${aws_route_table.tap_route_table.id}"
} 
# end resource
# end vpc.tf