data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Tier"
    values = ["public", "Public"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    authorized_key = "${file("~/.ssh/id_rsa.pub")}"
  }
}