# 部署指导书: 无服务器 TAK Server 华为云方案

## 1. 前置条件

### 1.1 华为云账号

- 已注册华为云账号
- 已完成实名认证

### 1.2 环境要求

| 要求 | 说明 |
|------|------|
| Docker | 用于构建 TAK Server 镜像 |
| kubectl | 用于部署到 CCE |
| helm | 用于包管理 |

### 1.3 必需的华为云资源

| 资源 | 说明 |
|------|------|
| CCE 集群 | 容器化部署 |
| GaussDB | 数据库服务 |
| SFS | 文件存储 |
| 增强型ELB | 负载均衡 |
| OBS | 对象存储 |
| CSMS | 密钥管理 |
| 云解析 DNS | 域名解析 |

## 2. 资源创建

### 2.1 创建 CCE 集群

通过控制台或 Terraform 创建 CCE 集群:

```bash
# Terraform 方式
resource "huaweicloud_cce_cluster" "cluster" {
  name        = "tak-cluster"
  flavor_id   = "cce.s2.small"
  vpc_id      = huaweicloud_vpc.vpc.id
  subnet_id   = huaweicloud_vpc_subnet.subnet.id
}
```

### 2.2 创建 GaussDB 数据库

```bash
# 创建 GaussDB 实例
resource "huaweicloud_gaussdb_instance" "instance" {
  name        = "tak-db"
  flavor     = "gaussdb.pro.xlarge"
  volume_size = 100
  vpc_id     = huaweicloud_vpc.vpc.id
  subnet_id  = huaweicloud_vpc_subnet.subnet.id
}
```

### 2.3 创建 SFS 文件存储

```bash
# 创建 SFS Turbo
resource "huaweicloud_sfs_turbo" "storage" {
  name        = "tak-storage"
  size        = 500
  vpc_id     = huaweicloud_vpc.vpc.id
  subnet_id  = huaweicloud_vpc_subnet.subnet.id
}
```

## 3. 构建 TAK Server 镜像

### 3.1 获取 TAK Server 发行版

TAK Server 发行版需要从官方获取:

```bash
# 从 tak.gov 或官方渠道获取 takserver-docker-distro
# 放置到项目根目录
```

### 3.2 构建 Docker 镜像

```bash
# 构建镜像
docker build -t tak-server:latest .

# 标记镜像
docker tag tak-server:latest registry.example.com/tak-server:latest

# 推送镜像到 SWR
docker push registry.example.com/tak-server:latest
```

## 4. 部署到 CCE

### 4.1 创建命名空间

```bash
kubectl create namespace tak
```

### 4.2 部署 TAK Server

```bash
# 部署
kubectl apply -f deployment.yaml

# 检查状态
kubectl get pods -n tak
```

## 5. 配置

### 5.1 环境变量

| 变量 | 说明 | 示例值 |
|------|------|--------|
| DB_HOST | 数据库地址 | gaussdb.internal.example.com |
| DB_PORT | 数据库端口 | 5432 |
| DB_NAME | 数据库名称 | takdb |
| DB_USER | 数据库用户 | takuser |
| SFS_PATH | SFS 挂载路径 | /tak/config |

### 5.2 配置域名

在云解析 DNS 中配置:
- `tak.yourdomain.com` → ELB 入口 IP

## 6. 验证

### 6.1 检查 Pod 状态

```bash
kubectl get pods -n tak
```

### 6.2 测试连接

```bash
# 测试 TAK Server
curl https://tak.yourdomain.com:8443/status

# 测试 LDAP (如果启用)
curl https://ldap.yourdomain.com
```

## 7. 清理资源

### 7.1 删除 CCE 资源

```bash
kubectl delete -f deployment.yaml
```

### 7.2 删除云资源

```bash
# 删除 GaussDB
huaweicloud_gaussdb_instance.instance

# 删除 SFS
huaweicloud_sfs_turbo.storage

# 删除 ELB
huaweicloud_elb_loadbalancer.loadbalancer
```

## 8. 故障排除

### 8.1 常见错误

| 错误 | 原因 | 解决方案 |
|------|------|----------|
| 容器启动失败 | 镜像拉取失败 | 检查镜像地址和 SWR 权限 |
| 数据库连接失败 | 安全组规则 | 开放数据库端口 |
| 负载均衡失败 | 健康检查失败 | 检查容器健康状态 |

### 8.2 日志

```bash
# 查看容器日志
kubectl logs -n tak tak-server-xxx

# 查看事件
kubectl get events -n tak
```
