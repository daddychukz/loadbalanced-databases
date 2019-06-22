#key pair

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}


resource "aws_instance" "master" {
  count = 4
  instance_type = "${var.instance_type}"
  ami           = "${var.ami}"

  tags {
    Name = "${element(local.tags, count.index)}"
  }

  key_name               = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${var.master_sg}"]
  subnet_id              = "${var.aws_instance_subnet_id}"
}

resource "null_resource" "provisioner" {
  count = 4
    provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts
[master]
${element(aws_instance.master.*.public_ip, 0)}
[master:vars]
haproxy_ip=${element(aws_instance.master.*.private_ip, 3)}
master_ip=${element(aws_instance.master.*.private_ip, 0)}
master_server_id=1
master_relay_log=

[slave1]
${element(aws_instance.master.*.public_ip, 1)}
[slave1:vars]
haproxy_ip=${element(aws_instance.master.*.private_ip, 3)}
slave1_ip=${element(aws_instance.master.*.private_ip, 1)}
slave1_server_id=2
slave1_relay_log=/var/log/mysql/mysql-relay-bin.log

[slave2]
${element(aws_instance.master.*.public_ip, 2)}
[slave2:vars]
haproxy_ip=${element(aws_instance.master.*.private_ip, 3)}
slave2_ip=${element(aws_instance.master.*.private_ip, 2)}
slave2_server_id=3
slave2_relay_log=/var/log/mysql/mysql-relay-bin.log

[haproxy]
${element(aws_instance.master.*.public_ip, 3)}
[haproxy:vars]
master_ip=${element(aws_instance.master.*.private_ip, 0)}
slave1_ip=${element(aws_instance.master.*.private_ip, 1)}
slave2_ip=${element(aws_instance.master.*.private_ip, 2)}
EOF
EOD
  }

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${element(aws_instance.master.*.id, count.index)} --profile chuka && ansible-playbook -i aws_hosts ${local.ansible-file[count.index]}"
  }
}

