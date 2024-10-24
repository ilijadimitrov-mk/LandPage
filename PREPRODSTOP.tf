module "preprod_stop" {
  source = "./modules/PREPRODSTOP"

  instance_name   = "landpage"
  ami_id          = data.aws_ami.latest_ubuntu.id
  instance_type   = "t3.xlarge"
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet1_id
  #subnet_id       = "subnet-7812a734"
  s3_bucket       = "ikosysops1010"
  security_groups = ["sg-781e0a18", "sg-0f955824571a02f42"]
  keypair         = "KeyPairforAMI"
  alb_sg_id       = "sg-781e0a18"
  ad_sg_id        = "sg-0f955824571a02f42"
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true

  owners = ["099720109477"]  # Canonical's account ID for Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]  # For Ubuntu 20.04 LTS
  }
}
