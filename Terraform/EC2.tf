module "ec2_instance_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion"

  instance_type          = "t2.micro"
  key_name               = "cicdassignmentbastion"
  monitoring             = true
  vpc_security_group_ids = ["sg-01744da57f56b7db1"]
  subnet_id              = "subnet-0ba14e8c0d6447064"

  tags = {
    name  = "bastion"
  }
}
module "ec2_instance_private1" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "private1"

  instance_type          = "t2.micro"
  key_name               = "cicdassignmentprivate1"
  monitoring             = true
  vpc_security_group_ids = ["sg-01744da57f56b7db1"]
  subnet_id              = "subnet-05848986f2a9aa7b5"

  tags = {
    name  = "private-machne1"
  }
}
module "ec2_instance_private2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "private2"

  instance_type          = "t2.micro"
  key_name               = "cicdassignmentprivate2"
  monitoring             = true
  vpc_security_group_ids = ["sg-01744da57f56b7db1"]
  subnet_id              = "subnet-0f6659363b48149d6"

  tags = {
    name  = "private-machne1"
  }
}