data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.tf_state_bucket
    key    = var.vpc_state_key
    region = var.tf_state_region
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.commontag}-ec2-sg"
  description = "Allow SSH (22) and HTTP (80)"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.commontag}-ec2-sg"
  }
}

resource "aws_instance" "prod_server" {
  ami                         = var.ami_image
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_1_id
  key_name                    = var.sshkeyname
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size_gb
  }

  tags = {
    Name = var.commontag
  }
}

