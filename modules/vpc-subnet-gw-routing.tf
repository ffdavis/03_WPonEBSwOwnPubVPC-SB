ssss/*
VPC Address	    Mask bits   hosts
172.28.0.0      /27         30

Subnet address	Netmask	          Range of addresses	          Useable IPs	                Hosts
172.28.0.0/28	  255.255.255.240	  172.28.0.0 - 172.28.0.15	    172.28.0.1 - 172.28.0.14	  14		
172.28.0.16/28	255.255.255.240	  172.28.0.16 - 172.28.0.31	    172.28.0.17 - 172.28.0.30	  14	
*/

resource "aws_vpc" "StoreOne-VPC" {
  cidr_block           = "173.28.0.0/27" # VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "StoreOne-VPC"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "StoreOne-SN1" {
  vpc_id     = "${aws_vpc.StoreOne-VPC.id}" # SN 1
  cidr_block = "173.28.0.0/28"

  tags {
    Name = "StoreOne-SN1"
  }

  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "StoreOne-SN2" {
  vpc_id     = "${aws_vpc.StoreOne-VPC.id}" # SN 2
  cidr_block = "173.28.0.16/28"

  tags {
    Name = "StoreOne-SN2"
  }

  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_internet_gateway" "StoreOne-GW" {
  vpc_id = "${aws_vpc.StoreOne-VPC.id}" # IGW

  tags = {
    Name = "StoreOne-GW"
  }
}

resource "aws_route_table" "StoreOne-RTPub" {
  vpc_id = "${aws_vpc.StoreOne-VPC.id}" # RT

  tags = {
    Name = "StoreOne-RTPub"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.StoreOne-GW.id}"
  }

  depends_on = ["aws_internet_gateway.StoreOne-GW"]
}

resource "aws_route_table_association" "StoreOne-RTA1" {
  subnet_id      = "${aws_subnet.StoreOne-SN1.id}"        # RTA 1 for SN 1
  route_table_id = "${aws_route_table.StoreOne-RTPub.id}"
}

resource "aws_route_table_association" "StoreOne-RTA2" {
  subnet_id      = "${aws_subnet.StoreOne-SN2.id}"        # RTA 2 for SN 2
  route_table_id = "${aws_route_table.StoreOne-RTPub.id}"
}
