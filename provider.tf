terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "5.13.1"

    }

  }
   backend "s3"{

        bucket = "mys3fortfstate"

        key = "terraform.tfstate"

        region = "us-east-1"

        encrypt = true

  }
}
