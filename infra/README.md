# TAK Server 基础设施代码

本目录包含使用 Terraform 部署 TAK Server 到华为云的完整基础设施代码。

## 资源清单

| 资源 | 说明 | Terraform 资源 |
|------|------|----------------|
| VPC | 虚拟私有云 | huaweicloud_vpc |
| 子网 | VPC 子网 | huaweicloud_vpc_subnet |
| 安全组 | 网络访问控制 | huaweicloud_networking_secgroup |
| CCE 集群 | 容器编排引擎 | huaweicloud_cce_cluster |
| CCE 节点池 | 容器节点 | huaweicloud_cce_node_pool |
| GaussDB | PostgreSQL 数据库 | huaweicloud_gaussdb_instance |
| SFS Turbo | 文件存储 | huaweicloud_sfs_turbo |
| OBS | 对象存储 | huaweicloud_obs_bucket |
| CSMS | 密钥管理 | huaweicloud_csms_secret |
| ELB | 增强型负载均衡 | huaweicloud_elb_loadbalancer |
| DNS | 云解析 | huaweicloud_dns_zone |

## 使用方法

### 1. 准备环境变量

```bash
# 设置华为云凭据
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"

# 设置敏感变量
export TF_VAR_gaussdb_password="your-db-password"
export TF_VAR_tak_admin_password="your-admin-password"
export TF_VAR_bucket_suffix="your-bucket-suffix"
```

### 2. 初始化 Terraform

```bash
cd infra
terraform init
```

### 3. 预览执行计划

```bash
terraform plan -var-file=prod.tfvars
```

### 4. 部署资源

```bash
terraform apply -var-file=prod.tfvars
```

### 5. 清理资源

```bash
terraform destroy -var-file=prod.tfvars
```

## 配置示例

创建 `prod.tfvars` 文件：

```hcl
region            = "cn-north-4"
project_name      = "tak-server"
bucket_suffix     = "abc123"

vpc_cidr          = "172.31.0.0/16"
subnet_cidr       = "172.31.10.0/24"
subnet_gateway    = "172.31.10.1"

cce_cluster_flavor = "cce.s2.small"
cce_node_flavor    = "s6.large.2"
cce_node_count     = 2

gaussdb_flavor     = "gaussdb.pro.xlarge"
gaussdb_volume_size = 100
gaussdb_database_name = "takdb"
gaussdb_username    = "takuser"

sfs_size           = 500
sfs_spec_code      = "sfs.turbo.std"

domain_name        = "tak.yourdomain.com"
dns_zone_name      = "tak.internal"
```

## 费用预估

| 资源 | 规格 | 预估费用（人民币/月） |
|------|------|---------------------|
| CCE 集群 | cce.s2.small | ¥200-300 |
| CCE 节点 | s6.large.2 x 2 | ¥400-500 |
| GaussDB | gaussdb.pro.xlarge | ¥1500-2000 |
| SFS Turbo | 500GB | ¥150-200 |
| ELB | 增强型 | ¥200-300 |
| OBS | 按需 | ¥50-100 |
| CSMS | 按需 | ¥10-20 |
| DNS | 按量 | ¥10-20 |
| **合计** | | **¥2500-3500** |

> 注意：以上为估算费用，实际费用以华为云控制台为准。

## 注意事项

1. **GaussDB 密码**：请通过环境变量 `TF_VAR_gaussdb_password` 注入，不要写入 tfvars 文件
2. **管理员密码**：请通过环境变量 `TF_VAR_tak_admin_password` 注入
3. **桶名唯一性**：OBS 桶名必须全局唯一，请设置 `bucket_suffix`
4. **CCE 节点**：生产环境建议至少 2 个节点保证高可用
5. **ELB 端口**：TAK 协议使用 TCP 8089 (HTTP) 和 8443 (HTTPS)
