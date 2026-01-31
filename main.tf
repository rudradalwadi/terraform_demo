# Existing VPC (Data Source)
# -----------------------------
data "aws_vpc" "vpc_id" {
  id = var.vpc_id
}

# Existing Subnet (Data Source)
# -----------------------------
data "aws_subnet" "subnet_id" {
  id = var.subnet_id
}

# Existing Key Pair (Data Source)
# -----------------------------
data "aws_key_pair" "key_pair_name" {
  key_name = var.key_pair_name
}

# Ubuntu 22.04 AMI
# -----------------------------
data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group (SSH only)
# -----------------------------
resource "aws_security_group" "ssh_sg" {
  name        = "ec2-ssh-sg"
  description = "Allow SSH access"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-ssh-sg"
  }
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "ubuntu_ec2" {
  count                  = var.instance_count
  depends_on             = [aws_security_group.ssh_sg]
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.subnet_id.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  key_name               = data.aws_key_pair.key_pair_name.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "Ubuntu-EC2-Instance-${count.index + 1}"
  }
}
# EBS Volume (Additional Storage)
# -----------------------------
resource "aws_ebs_volume" "additional_storage" {
  count             = var.instance_count
  availability_zone = aws_instance.ubuntu_ec2[count.index].availability_zone
  size              = 50  # 50 GB additional storage
  type              = "gp3"
  iops              = 3000
  throughput        = 125

  tags = {
    Name = "Ubuntu-EC2-Volume-${count.index + 1}"
  }
}

# EBS Volume Attachment
# -----------------------------
resource "aws_volume_attachment" "ebs_attach" {
  count           = var.instance_count
  device_name     = "/dev/sdf"
  volume_id       = aws_ebs_volume.additional_storage[count.index].id
  instance_id     = aws_instance.ubuntu_ec2[count.index].id
}