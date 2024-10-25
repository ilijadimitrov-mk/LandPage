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



  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apache2 awscli
              sudo apt-get install prometheus-node-exporter -y
              sudo apt-get install awscli -y
              sudo systemctl enable apache2
              sudo systemctl start apache2
              sudo apt install php libapache2-mod-php -y
              sudo apt install php-cli -y
              sudo apt install php-cgi -y
              sudo apt install php-pgsql -y
              sudo aws s3 cp s3://ikosysops1010/landpage/index.php  /var/www/html/index.php
              sudo mv  /var/www/html/index.html  /var/www/html/index_old.html
              sudo chmod 644 /var/www/html/index.php
              AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
              AWS_INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
              EC2_NAME=$(aws ec2 describe-tags --region $AWS_REGION --filters "Name=resource-id,Values=$AWS_INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
              sudo hostnamectl set-hostname `echo $EC2_NAME | tr "[:upper:]" "[:lower:]"`
              # for Ubuntu 20.04 (Focal)
              sudo sed -i "1 s|$| `echo $EC2_NAME | tr "[:upper:]" "[:lower:]"`|" "/etc/hosts"
              EOF


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

