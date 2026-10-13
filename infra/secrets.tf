# ============================================================================
# 密钥管理：CSMS 存储 TAK Server 凭证
# ============================================================================
# 注意：CSMS 凭据需在部署后通过控制台或 API 创建
# 此处仅定义变量占位，实际部署时通过环境变量注入

# TAK Server 凭证配置（本地变量，不存储到云端）
locals {
  tak_credentials = {
    DB_HOST     = huaweicloud_gaussdb_instance.main.nodes[0].private_ip
    DB_PORT     = "5432"
    DB_NAME     = var.gaussdb_database_name
    DB_USER     = var.gaussdb_username
    ADMIN_USER  = "admin"
  }

  tak_config = {
    TAK_VERSION      = var.tak_version
    TAK_HTTP_PORT    = var.tak_http_port
    TAK_HTTPS_PORT  = var.tak_https_port
    SFS_MOUNT_PATH  = "/tak/data"
    OBS_BUCKET      = huaweicloud_obs_bucket.main.bucket
  }
}
