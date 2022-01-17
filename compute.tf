resource "random_id" "mtc_node_id" {
  byte_length = 2
}


data "aws_ami" "server_ami" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "mtc_main" {
count = var.main_instance_count
ami   = data.aws_ami.server_ami.id
instance_type = var.main_instance_type
 key_name = aws_key_pair.mtc_auth.id
 vpc_security_group_ids = [aws_security_group.mtc_sg.id]
 subnet_id = aws_subnet.mtc_public_subnet[count.index].id
 root_block_device {
     volume_size = var.main_vol_size
 }
 user_data = templatefile("./main-userdata.tpl",{new_hostname = "mtc_main + ${count.index + 1} + ${random_id.mtc_node_id.dec}" })
  tags = {
    Name = "mtc_main + ${count.index + 1} + ${random_id.mtc_node_id.dec}"
  }
}