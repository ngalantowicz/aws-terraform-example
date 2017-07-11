######################################################
# Tells terraform I'm using AWS and want to provision
# the below resources in the region stated
provider "aws" {
  region     = "us-west-2"
}

#####################################################
# Generates ec2 resource with desired services
resource "aws_instance" "example-instance" {
  count                        = 1
  ami                          = "ami-4836a428"
  instance_type                = "t2.micro"
  vpc_security_group_ids       = ["${aws_security_group.instance.id}"]
  key_name                     = "your_personal_key"

  tags {
    Name = "example-instance"
  }
}

###################################################################
# Provisions new security group specific for the above EC2, which
# allows ssh on port 22, http on port 80 and outbond traffic on all ports
resource "aws_security_group" "instance" {
  name = "example-instance"

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

##################################################################################################
# The null_resource below provisions not an explicit AWS service but rather extra actions to run
# when I execute this main.tf file.  The first provisioner attaches the newly created EC2's IP into
# my ansible inventory.ini file.  The second provisioner executes the ansible playbook that
# the copys the html dir into the new EC2 server, installs NGINX, points NGINX to the html dir,
# and starts NGINX
resource "null_resource" "jrwebdev" {

  triggers {
    cluster_instance_ids = "${aws_instance.example-instance.id}"
  }

  provisioner "local-exec" {
    command = "sed -i -e '2s/.*/${aws_instance.example-instance.public_ip}/' deploy-jrwebdev/inventory.ini"
  }

  provisioner "local-exec" {
    command = "cd deploy-jrwebdev && ansible-playbook -i inventory.ini playbook-jrwebdev.yml"
  }
}
