# ============================================================================
# 网络层：VPC + 子网 + 安全组
# ============================================================================

# VPC
resource "huaweicloud_vpc" "main" {
  name                  = "${var.project_name}-vpc"
  cidr                  = var.vpc_cidr
  enterprise_project_id = "0"

  tags = var.tags
}

# 子网
resource "huaweicloud_vpc_subnet" "main" {
  name       = "${var.project_name}-subnet"
  vpc_id     = huaweicloud_vpc.main.id
  cidr       = var.subnet_cidr
  gateway_ip = var.subnet_gateway

  tags = var.tags
}

# 安全组：TAK Server
resource "huaweicloud_networking_secgroup" "tak" {
  name        = "${var.project_name}-sg"
  description = "Security group for TAK Server"

  tags = var.tags
}

# 安全组规则：TAK HTTP
resource "huaweicloud_networking_secgroup_rule" "tak_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = var.tak_http_port
  port_range_max    = var.tak_http_port
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.tak.id
}

# 安全组规则：TAK HTTPS
resource "huaweicloud_networking_secgroup_rule" "tak_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = var.tak_https_port
  port_range_max    = var.tak_https_port
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.tak.id
}

# 安全组规则：PostgreSQL 数据库
resource "huaweicloud_networking_secgroup_rule" "tak_db" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = var.subnet_cidr
  security_group_id = huaweicloud_networking_secgroup.tak.id
}

# 安全组规则：SFS NFS
resource "huaweicloud_networking_secgroup_rule" "tak_nfs" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2049
  port_range_max    = 2049
  remote_ip_prefix  = var.subnet_cidr
  security_group_id = huaweicloud_networking_secgroup.tak.id
}

# 安全组规则：允许所有出站
resource "huaweicloud_networking_secgroup_rule" "tak_egress_all" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.tak.id
}
