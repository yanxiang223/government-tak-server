# ============================================================================
# GaussDB 数据库：TAK Server 数据存储
# ============================================================================

resource "huaweicloud_gaussdb_instance" "main" {
  name              = "${var.project_name}-db"
  flavor            = var.gaussdb_flavor
  vpc_id            = huaweicloud_vpc.main.id
  subnet_id         = huaweicloud_vpc_subnet.main.id
  security_group_id = huaweicloud_networking_secgroup.tak.id

  availability_zone = "${var.region}a"

  password = var.gaussdb_password

  volume {
    size = var.gaussdb_volume_size
    type = "ULTRAHIGH"
  }

  ha {
    mode              = "ha"
    replication_mode = "async"
  }

  tags = var.tags
}
