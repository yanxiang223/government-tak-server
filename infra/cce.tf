# ============================================================================
# CCE 集群：容器化部署 TAK Server
# ============================================================================

# CCE 集群
resource "huaweicloud_cce_cluster" "main" {
  name                   = "${var.project_name}-cluster"
  cluster_type           = "VirtualMachine"
  flavor_id              = var.cce_cluster_flavor
  vpc_id                 = huaweicloud_vpc.main.id
  subnet_id              = huaweicloud_vpc_subnet.main.id
  container_network_type = "VPC-Network"
  cluster_version        = var.cce_cluster_version

  tags = var.tags
}

# CCE 节点池
resource "huaweicloud_cce_node_pool" "main" {
  cluster_id        = huaweicloud_cce_cluster.main.id
  name              = "${var.project_name}-nodepool"
  flavor_id         = var.cce_node_flavor
  initial_node_count = var.cce_node_count
  availability_zone = "${var.region}a"
  subnet_id         = huaweicloud_vpc_subnet.main.id

  root_volume {
    size       = var.cce_node_root_volume_size
    volumetype = "SSD"
  }

  data_volumes {
    size       = var.cce_node_data_volume_size
    volumetype = "SSD"
  }

  # 密钥对或密码必须二选一
  key_pair = var.cce_key_pair != "" ? var.cce_key_pair : null

  tags = var.tags
}

# IAM 委托：CCE 访问 OBS/CSMS
resource "huaweicloud_identity_agency" "cce" {
  name                  = "${var.project_name}-cce-agency"
  description           = "Agency for CCE to access OBS/CSMS"
  duration              = "FOREVER"
  delegated_domain_name = "huaweicloud"

  project_role {
    project = var.region
    roles = [
      "OBS OperateAccess",
      "CSMS FullAccess",
    ]
  }
}
