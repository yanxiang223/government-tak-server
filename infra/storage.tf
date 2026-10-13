# ============================================================================
# 存储层：SFS Turbo + OBS
# ============================================================================

# SFS Turbo 文件存储：TAK 配置持久化
resource "huaweicloud_sfs_turbo" "main" {
  name              = "${var.project_name}-storage"
  size              = var.sfs_size
  vpc_id            = huaweicloud_vpc.main.id
  subnet_id         = huaweicloud_vpc_subnet.main.id
  security_group_id = huaweicloud_networking_secgroup.tak.id
  availability_zone = "${var.region}a"

  tags = var.tags
}

# OBS 桶：证书和数据存储
resource "huaweicloud_obs_bucket" "main" {
  bucket = var.obs_bucket_name != "" ? var.obs_bucket_name : "${var.project_name}-${var.bucket_suffix}"

  acl           = "private"
  force_destroy = true
  versioning    = true

  tags = var.tags
}

# OBS 桶策略：允许 CCE 读取
resource "huaweicloud_obs_bucket_policy" "main" {
  bucket = huaweicloud_obs_bucket.main.bucket

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid       = "CCE Access"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource = [
          "arn:aws:s3:::${huaweicloud_obs_bucket.main.bucket}/*"
        ]
      }
    ]
  })
}
