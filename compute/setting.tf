locals {
  tags = [
      "Master",
      "Slave1",
      "Slave2",
      "HAProxy"
  ]
  ansible-file = [
      "master.yml",
      "slave1.yml",
      "slave2.yml",
      "haproxy.yml"
  ]
}
