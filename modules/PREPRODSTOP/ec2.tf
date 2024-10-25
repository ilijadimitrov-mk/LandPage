locals {
  vars = {
    s3_url   = var.s3_url
  }
}


resource "aws_instance" "preprod_instance" {
  ami                    = var.ami_id
  instance_type         = var.instance_type
  vpc_security_group_ids =  [aws_security_group.allow_alb.id, "sg-781e0a18"] 
  #vpc_security_group_ids = var.security_groups
  subnet_id             = var.subnet_id
  associate_public_ip_address = true
  key_name = var.keypair

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  #iam_instance_profile = aws_iam_role.ec2_role.name

  user_data = templatefile("${path.module}/userdata.sh", local.vars)

lifecycle {
    ignore_changes = [
      ami,
      user_data
    ]
  }


  tags = {
    Name = var.instance_name
  }
}

