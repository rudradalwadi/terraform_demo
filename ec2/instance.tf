resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3"
  }

  tags = {
    Name = var.name
  }
}
