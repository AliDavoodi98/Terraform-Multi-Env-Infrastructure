data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "DHCP-AMI"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "dhcp-server-instance" {
  ami = data.aws_ami.ubuntu.id 
  instance_type = "t3.micro"
  subnet_id = var.dhcp_subnet

  tags = {
    Name = "DHCP Server"
  }
}