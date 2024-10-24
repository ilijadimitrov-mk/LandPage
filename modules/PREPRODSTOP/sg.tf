resource "aws_security_group" "allow_alb" {
  vpc_id = var.vpc_id
  name        = "${var.instance_name}-web_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]  # Replace with your ALB Security Group ID
    # cidr_blocks = ["0.0.0.0/0"]  # Update this as needed
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.ad_sg_id]  # Replace with your ALB Security Group ID
    # cidr_blocks = ["0.0.0.0/0"]  # Update this as needed
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
