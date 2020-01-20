
# Allow bastion to connect
resource "aws_security_group" "security_group" {
  name        = local.name_identifier
  description = "Allow traffic for pioneer instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow either bastion or direct ssh access to host, not both.
resource "aws_security_group_rule" "allow_ssh_rule" {
  count             = var.enable_bastion ? 0 : "${var.enable_ssh ? 1 : 0}"
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_cidr_blocks
  to_port           = 22
  type              = "ingress"
  security_group_id = aws_security_group.security_group.id
}

# Create rule if bastion is enable
resource "aws_security_group_rule" "allow_ssh_from_bastion" {
  count                    = var.enable_bastion ? 1 : 0
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security_group.id
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = var.bastion_source_sg
}

resource "aws_security_group_rule" "allow_http_rule" {
  from_port         = 80
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  to_port           = 80
  type              = "ingress"
  security_group_id = aws_security_group.security_group.id
}
