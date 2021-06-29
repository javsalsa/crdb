
provider "aws" {
  region  = var.region
}

resource "aws_instance" "node1" {
  ami           = var.ami
  instance_type = var.instancetype
  subnet_id = var.subnet1
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.sshkey
  disable_api_termination = false
  iam_instance_profile = aws_iam_instance_profile.crdbnode-profile.id
  root_block_device  {
    volume_size = var.rootvolumesize
    volume_type = "gp3"
  }
  user_data = file("install.sh")
  depends_on = [
    aws_ebs_volume.data1,
    ]
  tags = {
    Name = "crdb-node-1",
    Role = "crdbnode",
    Clustername = "crdbrestore"
  }
}

resource "aws_ebs_volume" "data1" {
  availability_zone = "us-east-1a"
  size              = var.datavolumesize
  type              = "gp3"

  tags = {
    Name = "crdbdata-us-east-1a"
  }
}

resource "aws_volume_attachment" "ebs_att1" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data1.id
  instance_id = aws_instance.node1.id
}

resource "aws_instance" "node2" {
  ami           = var.ami
  instance_type = var.instancetype
  subnet_id = var.subnet2
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.sshkey
  disable_api_termination = false
  iam_instance_profile = aws_iam_instance_profile.crdbnode-profile.id
  root_block_device  {
    volume_size = var.rootvolumesize
    volume_type = "gp3"
  }
  user_data = file("install.sh")
  depends_on = [
    aws_ebs_volume.data2,
    ]
  tags = {
    Name = "crdb-node-2",
    Role = "crdbnode",
    Clustername = "crdbrestore"
  }
}

resource "aws_ebs_volume" "data2" {
  availability_zone = "us-east-1b"
  size              = var.datavolumesize
  type              = "gp3"

  tags = {
    Name = "crdbdata-us-east-1b"
  }
}

resource "aws_volume_attachment" "ebs_att2" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data2.id
  instance_id = aws_instance.node2.id
}

resource "aws_instance" "node3" {
  ami           = var.ami
  instance_type = var.instancetype
  subnet_id = var.subnet3
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.sshkey
  disable_api_termination = false
  iam_instance_profile = aws_iam_instance_profile.crdbnode-profile.id
  root_block_device  {
    volume_size = var.rootvolumesize
    volume_type = "gp3"
  }
  user_data = file("install.sh")
  depends_on = [
    aws_ebs_volume.data3,
    ]
  tags = {
    Name = "crdb-node-3",
    Role = "crdbnode",
    Clustername = "crdbrestore"
  }
}

resource "aws_ebs_volume" "data3" {
  availability_zone = "us-east-1c"
  size              = var.datavolumesize
  type              = "gp3"

  tags = {
    Name = "crdbdata-us-east-1c"
  }
}

resource "aws_volume_attachment" "ebs_att3" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data3.id
  instance_id = aws_instance.node3.id
}
