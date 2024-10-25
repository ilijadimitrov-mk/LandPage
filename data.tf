data "aws_ami" "latest_ubuntu" {
  most_recent = true

  owners = ["099720109477"]  # Canonical's account ID for Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]  # For Ubuntu 20.04 LTS
  }
}

