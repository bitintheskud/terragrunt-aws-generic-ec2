data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    authorized_key = "${file("~/.ssh/id_rsa.pub")}"
  }
}
