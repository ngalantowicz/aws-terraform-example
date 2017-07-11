provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "dicky-instance" {
  count                        = 1
  ami                          = "ami-4836a428"
  instance_type                = "t2.micro"
  vpc_security_group_ids       = ["${aws_security_group.instance.id}"]
  key_name                     = "your_personal_key"

  tags {
    Name = "dicky-test"
  }
}

resource "aws_security_group" "instance" {
  name = "dicky-test-instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "all_outbound" {
  security_group_id = "${aws_security_group.instance.id}"

  type = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  security_group_id = "${aws_security_group.instance.id}"

  type = "ingress"

  from_port   = 80
  to_port     = 80
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "null_resource" "jrwebdev" {

  triggers {
    cluster_instance_ids = "${aws_instance.dicky-instance.id}"
  }

  provisioner "local-exec" {
    command = "sed -i -e '2s/.*/${aws_instance.dicky-instance.public_ip}/' deploy-jrwebdev/inventory.ini"
  }

  provisioner "local-exec" {
    command = "cd deploy-jrwebdev && ansible-playbook -i inventory.ini playbook-jrwebdev.yml"
  }
}
