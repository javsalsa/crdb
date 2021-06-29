resource "aws_security_group" "sg" {
  name        = "cockroachdb-sg"
  description = "cockroachdb-sg"
  vpc_id      = var.vpc

  ingress {
    description = "DB Console"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = var.sg-cidr-dbconsole
  }

  ingress {
    description = "Application Data"
    from_port        = 26257
    to_port          = 26257
    protocol         = "tcp"
    cidr_blocks      = var.sg-cidr-crdbnodes
  }

  ingress {
    description = "Application Data Rule"
    from_port        = 26257
    to_port          = 26257
    protocol         = "tcp"
    self             = true
  }

  ingress {
    description = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.sg-cidr-ssh
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cockroachdb-sg"
  }
}
