# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-bucket-rea"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

# Use AWS Terraform provider
provider "aws" {
  region = "us-east-2"
}

# Create EC2 instance
resource "aws_instance" "default" {
  ami                    = var.ami
  private_ip             = "172.31.3.86"
  count                  = var.instance_count
  key_name               = var.key_name
  source_dest_check      = false
  instance_type          = var.instance_type
  subnet_id              = "subnet-25f8094e"
  vpc_security_group_ids  = ["sg-058bf7e7e208d1380"]

    tags = {
        Name          = "REA_Group_Dev_ENV"
        Deployment    = "SinatraAPP"
        Environment   = "SinatraAPP_Dev"
        It_Owner = "izzychen0611@gmail.com"
      }
}
