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
  private_ip             = "172.31.44.185"
  count                  = var.instance_count
  key_name               = var.key_name
  vpc_security_group_ids = "vpc-31aa635a"
  source_dest_check      = false
  instance_type          = var.instance_type
  subnet_id               = "subnet-25f8094e"

  provisioner "file" {
      source      = "files/authorized_keys"
      destination = "/home/ec2-user/.ssh/authorized_keys"
      connection {
        type        = "ssh"
        user        = "ec2-user"
        host        = "172.31.44.185"
        private_key = "${file("files/REA_Instance.pem")}"
      }
    }

    tags = {
        Name          = "REA_Group_Ruby_ENV"
        Deployment    = "SinatraAPP"
        Environment   = "SinatraAPP_Dev"
        It_Owner = "izzychen0611@gmail.com"
      }
}



# Create Security Group for EC2
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 9292
      to_port     = 9292
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
