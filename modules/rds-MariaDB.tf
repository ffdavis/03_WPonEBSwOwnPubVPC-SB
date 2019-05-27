#-----
# Pulling data resource for private subnets with relevant tag
/* 
# 3 #
data "aws_subnet_ids" "sn1a" {
  vpc_id = "${aws_default_vpc.default.id}"

  tags = {
    Name = "AWS-SN-use1a-Def"
  }
}

data "aws_subnet_ids" "sn1b" {
  vpc_id = "${aws_default_vpc.default.id}"

  tags = {
    Name = "AWS-SN-use1b-Def"
  }
}
*/
# ----
# 1 # data "aws_subnet_ids" "public" {
#  vpc_id = "${aws_default_vpc.default.id}"
#}
# subnet_ids = ["${element(data.aws_subnet_ids.public.ids, 0)}", "${element(data.aws_subnet_ids.public.ids, 1)}"]

resource "aws_db_instance" "storeone-db" {
  identifier             = "storeonedb"                               # DB Instance
  allocated_storage      = "5"
  storage_type           = "gp2"
  engine                 = "MariaDB"
  engine_version         = "10.2.21"
  instance_class         = "db.t2.micro"
  name                   = "storeonedb"
  username               = "rootfer"
  password               = "cacarulo99"
  parameter_group_name   = "default.mariadb10.2"
  skip_final_snapshot    = true                                       # this setup will allow to delete the RDS with terraform destroy.
  depends_on             = ["aws_security_group.StoreOneSG-DB"]
  vpc_security_group_ids = ["${aws_security_group.StoreOneSG-DB.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.StoreOne-SNG.id}"
  multi_az               = false
  publicly_accessible    = true
}

resource "aws_db_subnet_group" "StoreOne-SNG" {
  name = "main"

  # 2 # subnet_ids = ["subnet-47aac569", "subnet-5bf5c511"]
  # 3 # subnet_ids = ["${element(data.aws_subnet_ids.sn1a.ids, 0)}", "${element(data.aws_subnet_ids.sn1b.ids, 0)}"]
  subnet_ids = ["${aws_subnet.StoreOne-SN1.id}", "${aws_subnet.StoreOne-SN2.id}"]
}
