# ============================================================================
# 负载均衡：增强型 ELB
# ============================================================================

# 增强型 ELB
resource "huaweicloud_elb_loadbalancer" "main" {
  name               = "${var.project_name}-elb"
  loadbalancer_type  = var.elb_type
  vpc_id             = huaweicloud_vpc.main.id
  backend_subnets    = [huaweicloud_vpc_subnet.main.id]

  availability_zone = ["${var.region}a"]

  tags = var.tags
}

# TCP 监听器：TAK HTTP
resource "huaweicloud_elb_listener" "tak_http" {
  name            = "${var.project_name}-http"
  protocol        = "TCP"
  loadbalancer_id = huaweicloud_elb_loadbalancer.main.id

  idle_timeout     = 3600
  request_timeout = 300
}

# TCP 监听器：TAK HTTPS
resource "huaweicloud_elb_listener" "tak_https" {
  name            = "${var.project_name}-https"
  protocol        = "TCP"
  loadbalancer_id = huaweicloud_elb_loadbalancer.main.id

  idle_timeout     = 3600
  request_timeout  = 300
}

# TCP 池
resource "huaweicloud_elb_pool" "tcp" {
  name        = "${var.project_name}-tcp"
  protocol    = "TCP"
  lb_method   = "round_robin"
  listener_id = huaweicloud_elb_listener.tak_http.id
}
