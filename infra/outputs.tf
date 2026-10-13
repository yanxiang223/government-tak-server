# ============================================================================
# 输出
# ============================================================================

output "cce_cluster_id" {
  description = "CCE 集群 ID"
  value       = huaweicloud_cce_cluster.main.id
}

output "cce_cluster_name" {
  description = "CCE 集群名称"
  value       = huaweicloud_cce_cluster.main.name
}

output "gaussdb_endpoint" {
  description = "GaussDB 连接地址"
  value       = huaweicloud_gaussdb_instance.main.nodes[0].private_ip
}

output "gaussdb_port" {
  description = "GaussDB 端口"
  value       = 5432
}

output "sfs_id" {
  description = "SFS Turbo ID"
  value       = huaweicloud_sfs_turbo.main.id
}

output "obs_bucket_name" {
  description = "OBS 桶名"
  value       = huaweicloud_obs_bucket.main.bucket
}

output "elb_ip" {
  description = "ELB IP 地址"
  value       = huaweicloud_elb_loadbalancer.main.ipv4_address
}

output "dns_zone_id" {
  description = "DNS Zone ID"
  value       = huaweicloud_dns_zone.private.id
}

output "tak_deployment_info" {
  description = "TAK Server 部署信息"
  value = {
    cce_cluster    = huaweicloud_cce_cluster.main.name
    gaussdb        = huaweicloud_gaussdb_instance.main.nodes[0].private_ip
    sfs            = huaweicloud_sfs_turbo.main.id
    obs            = huaweicloud_obs_bucket.main.bucket
    elb            = huaweicloud_elb_loadbalancer.main.ipv4_address
    http_port      = var.tak_http_port
    https_port     = var.tak_https_port
  }
}
