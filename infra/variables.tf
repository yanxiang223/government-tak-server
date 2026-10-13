# ============================================================================
# 输入变量
# ============================================================================

variable "region" {
  description = "华为云区域"
  type        = string
  default     = "cn-north-4"
}

variable "project_name" {
  description = "资源命名前缀，需全局唯一性友好（小写字母/数字/连字符）"
  type        = string
  default     = "tak-server"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.project_name))
    error_message = "project_name 只能包含小写字母、数字和连字符，长度 2-21，且以字母开头。"
  }
}

variable "bucket_suffix" {
  description = "OBS 桶名后缀，用于保证桶名全局唯一（建议填账号短 ID 或随机串）"
  type        = string
}

# ---------------------------------------------------------------------------
# 网络
# ---------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC 网段"
  type        = string
  default     = "172.31.0.0/16"
}

variable "subnet_cidr" {
  description = "子网网段"
  type        = string
  default     = "172.31.10.0/24"
}

variable "subnet_gateway" {
  description = "子网网关地址"
  type        = string
  default     = "172.31.10.1"
}

# ---------------------------------------------------------------------------
# CCE 集群
# ---------------------------------------------------------------------------

variable "cce_cluster_flavor" {
  description = "CCE 集群规格"
  type        = string
  default     = "cce.s2.small"
}

variable "cce_cluster_version" {
  description = "CCE 集群版本"
  type        = string
  default     = "v1.29"
}

variable "cce_node_flavor" {
  description = "CCE 节点规格"
  type        = string
  default     = "s6.large.2"
}

variable "cce_node_count" {
  description = "CCE 节点数量"
  type        = number
  default     = 2
}

variable "cce_key_pair" {
  description = "CCE 节点登录密钥对名称"
  type        = string
  default     = ""
}

variable "cce_node_root_volume_size" {
  description = "CCE 节点系统盘大小（GB）"
  type        = number
  default     = 40
}

variable "cce_node_data_volume_size" {
  description = "CCE 节点数据盘大小（GB）"
  type        = number
  default     = 100
}

# ---------------------------------------------------------------------------
# GaussDB 数据库
# ---------------------------------------------------------------------------

variable "gaussdb_flavor" {
  description = <<-EOT
    GaussDB 实例规格。与计费直接相关，必须显式指定。
    可用规格查询：
      terraform console
      > data.huaweicloud_gaussdb_flavors.available.flavors
    或控制台「GaussDB → 购买实例」页面查看。
  EOT
  type        = string
  default     = "gaussdb.pro.xlarge"
}

variable "gaussdb_volume_size" {
  description = "GaussDB 存储容量（GB）"
  type        = number
  default     = 100
}

variable "gaussdb_password" {
  description = "GaussDB 实例密码。请通过 TF_VAR_gaussdb_password 环境变量注入，不要写入 tfvars 文件"
  type        = string
  sensitive   = true
}

variable "gaussdb_database_name" {
  description = "TAK 数据库名称"
  type        = string
  default     = "takdb"
}

variable "gaussdb_username" {
  description = "TAK 数据库用户名"
  type        = string
  default     = "takuser"
}

# ---------------------------------------------------------------------------
# SFS Turbo 文件存储
# ---------------------------------------------------------------------------

variable "sfs_size" {
  description = "SFS Turbo 存储容量（GB）"
  type        = number
  default     = 500
}

variable "sfs_spec_code" {
  description = "SFS Turbo 规格码"
  type        = string
  default     = "sfs.turbo.std"
}

# ---------------------------------------------------------------------------
# OBS 对象存储
# ---------------------------------------------------------------------------

variable "obs_bucket_name" {
  description = "OBS 桶名（全局唯一）"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# 密钥管理
# ---------------------------------------------------------------------------

variable "tak_admin_password" {
  description = "TAK Server 管理员密码。请通过 TF_VAR_tak_admin_password 环境变量注入"
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------
# DNS 域名
# ---------------------------------------------------------------------------

variable "domain_name" {
  description = "TAK Server 访问域名"
  type        = string
  default     = ""
}

variable "dns_zone_name" {
  description = "云解析 Private Zone 名称"
  type        = string
  default     = "tak.internal"
}

# ---------------------------------------------------------------------------
# ELB 负载均衡
# ---------------------------------------------------------------------------

variable "elb_type" {
  description = "ELB 类型：performance（增强型）or basic（共享型）"
  type        = string
  default     = "performance"
}

variable "elb_eip_id" {
  description = "ELB 绑定的弹性公网 IP ID。留空则仅内网访问"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# TAK Server 配置
# ---------------------------------------------------------------------------

variable "tak_version" {
  description = "TAK Server 版本"
  type        = string
  default     = "5.4.0"
}

variable "tak_http_port" {
  description = "TAK Server HTTP 端口"
  type        = number
  default     = 8089
}

variable "tak_https_port" {
  description = "TAK Server HTTPS 端口"
  type        = number
  default     = 8443
}

variable "tak_replicas" {
  description = "TAK Server Pod 副本数"
  type        = number
  default     = 2
}

variable "tak_cpu_request" {
  description = "TAK Server CPU 请求（m）"
  type        = string
  default     = "500"
}

variable "tak_cpu_limit" {
  description = "TAK Server CPU 限制（m）"
  type        = string
  default     = "2000"
}

variable "tak_memory_request" {
  description = "TAK Server 内存请求（Mi）"
  type        = string
  default     = "1024"
}

variable "tak_memory_limit" {
  description = "TAK Server 内存限制（Mi）"
  type        = string
  default     = "4096"
}

# ---------------------------------------------------------------------------
# 标签
# ---------------------------------------------------------------------------

variable "tags" {
  description = "统一资源标签"
  type        = map(string)
  default = {
    application = "tak-server"
    managed_by  = "terraform"
  }
}
