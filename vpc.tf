provider "aws" {

  region = "us-east-1"  # Update this to your desired region

}

resource "aws_key_pair" "my_key_pair" {

  key_name   = "my-key-pair"

  public_key = file("./id_rsa.pub.pub") 

}


module "custom_vpc" {

  source = "terraform-aws-modules/vpc/aws"



  name = "c6assignment-vpcc"

  cidr = "10.0.0.0/16"



  azs             = ["us-east-1a", "us-east-1b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]



  enable_nat_gateway = true



  tags = {

    Terraform   = "true"

    Environment = "dev"

  }

}



output "vpc_id" {

  value = module.custom_vpc.vpc_id

}



output "public_subnet_ids" {

  value = module.custom_vpc.public_subnets

}



output "private_subnet_ids" {

  value = module.custom_vpc.private_subnets

}



resource "aws_security_group" "bastion_sg" {

  vpc_id = module.custom_vpc.vpc_id



  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }



  # No ingress rule for now

}



resource "aws_security_group" "private_instances_sg" {

  vpc_id = module.custom_vpc.vpc_id



  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }



  # No ingress rule for now

}



resource "aws_security_group" "public_web_sg" {

  vpc_id = module.custom_vpc.vpc_id



  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }



  ingress {

    from_port   = 80

    to_port     = 80

    protocol    = "tcp"

    cidr_blocks = [data.external.public_ip.result.allowed_ip_cidr]

  }

}



resource "aws_instance" "bastion" {

  ami           = "ami-053b0d53c279acc90"

  instance_type = "t2.micro"
  
  subnet_id     = module.custom_vpc.public_subnets[0]
  key_name      = "MyKeyPrair"
  associate_public_ip_address = true 
  tags = {
      Name = "bastion"
  }
  security_groups = [aws_security_group.bastion_sg.id]

}



resource "aws_instance" "jenkins" {

  ami           = "ami-053b0d53c279acc90"

  instance_type = "t2.micro"
  

  subnet_id     = module.custom_vpc.private_subnets[0]
  key_name      = "MyKeyPrair"
  tags = {

      Name = "jenkins"

  }

  security_groups = [aws_security_group.private_instances_sg.id]

}



resource "aws_instance" "app" {

  ami           = "ami-053b0d53c279acc90"

  instance_type = "t2.micro"
 


  subnet_id     = module.custom_vpc.private_subnets[1]
  key_name      = "MyKeyPrair"
  tags =  {

      Name = "app"

  }
  security_groups = [aws_security_group.private_instances_sg.id]

}



resource "aws_lb" "app_lb" {

  name               = "app-lb"

  internal           = false

  load_balancer_type = "application"

  security_groups   = [aws_security_group.public_web_sg.id]

  subnets            = module.custom_vpc.public_subnets

}

data "external" "public_ip" {

  program = ["./get_public_ip.sh"]

}



locals {

  self_ip = data.external.public_ip.result

}
