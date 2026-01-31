data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_subnet" "existing" {
  id = var.subnet_id
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.generated.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/${var.key_pair_name}.pem"
  content         = tls_private_key.generated.private_key_pem
  file_permission = "0600"
}
resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}

data "aws_iam_policy_document" "lb_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name   = "test"
  user   = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.lb_ro.json
}
# -----------------------------
# EC2 INSTANCE 1
# -----------------------------
module "ec2_1" {
  source = "./modules/ec2"

  name          = "ec2-1"
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.ec2_1_instance_type
  disk_size     = var.ec2_1_disk_size

  subnet_id = data.aws_subnet.existing.id
  key_name  = aws_key_pair.generated.key_name
}

# -----------------------------
# EC2 INSTANCE 2
# -----------------------------
module "ec2_2" {
  source = "./modules/ec2"

  name          = "ec2-2"
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.ec2_2_instance_type
  disk_size     = var.ec2_2_disk_size

  subnet_id = data.aws_subnet.existing.id
  key_name  = aws_key_pair.generated.key_name
}

# -----------------------------
# EC2 INSTANCE 3
# -----------------------------
module "ec2_3" {
  source = "./modules/ec2"

  name          = "ec2-3"
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.ec2_3_instance_type
  disk_size     = var.ec2_3_disk_size
  subnet_id = data.aws_subnet.existing.id
  key_name  = aws_key_pair.generated.key_name
}



# -----------------------------
# S3
# -----------------------------
module "s3_bucket" {
  source = "./modules/s3"
  depends_on = [ module.ec2_1, module.ec2_2, module.ec2_3 ]

  bucket_name = var.s3_bucket_name
  environment = var.s3_environment
}