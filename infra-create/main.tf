resource "aws_instance" "tool" {
  ami                    = data.aws_ami.rhel9.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "tool-sg" {
  name        = "${var.name}-sg"
  description = "${var.name}-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.key
    }
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_route53_record" "record-public" {
  zone_id = var.hosted_zone_id
  name    = var.name
  type    = "A"
  ttl     = 10
  records = [aws_instance.tool.public_ip]
}

resource "aws_route53_record" "record-private" {
  zone_id = var.hosted_zone_id
  name    = "${var.name}-internal"
  type    = "A"
  ttl     = 10
  records = [aws_instance.tool.private_ip]
}
