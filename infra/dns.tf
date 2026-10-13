# ============================================================================
# DNS：云解析 Private Zone
# ============================================================================

# Private Zone
resource "huaweicloud_dns_zone" "private" {
  name        = var.dns_zone_name
  description = "TAK Server private zone"
  zone_type   = "private"

  tags = var.tags
}

# Private Zone 关联 VPC
resource "huaweicloud_dns_recordset" "vpc_associate" {
  zone_id    = huaweicloud_dns_zone.private.id
  name       = var.dns_zone_name
  type       = "NS"
  ttl        = 300
  records    = ["ns1.huaweicloud-dns.com", "ns2.huaweicloud-dns.com"]
}

# A 记录：TAK Server
resource "huaweicloud_dns_recordset" "tak" {
  count = var.domain_name != "" ? 1 : 0

  zone_id    = huaweicloud_dns_zone.private.id
  name       = var.domain_name
  type       = "A"
  ttl        = 300
  records    = [huaweicloud_elb_loadbalancer.main.ipv4_address]
}

# CNAME 记录：tak-alias
resource "huaweicloud_dns_recordset" "tak_alias" {
  zone_id    = huaweicloud_dns_zone.private.id
  name       = "tak.${var.dns_zone_name}"
  type       = "CNAME"
  ttl        = 300
  records    = [var.domain_name != "" ? var.domain_name : huaweicloud_elb_loadbalancer.main.ipv4_address]
}
