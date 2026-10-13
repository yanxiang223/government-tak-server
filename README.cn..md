# 无服务器 TAK Server 华为云方案

![License](https://img.shields.io/badge/License-MIT-green)

## 简介

本方案展示如何在华为云上部署无服务器 TAK Server (Team Awareness Kit)，实现高可用、自动扩展且成本优化的协作平台。

TAK 是一种情境感知和地理空间协作软件，最初为军事行动创建，现已广泛应用于应急管理、灾害响应、执法和搜救行动。

### 核心功能

- **无服务器架构**: 自动扩展的计算和数据库资源
- **高可用性**: 跨多可用区部署
- **成本优化**: 按需付费，自动扩展至零
- **增强安全性**: 网络隔离和密钥管理

## 方案亮点

- 云原生容器化部署
- 自动扩展架构
- 高可用多AZ设计
- 简化运维

## 前置条件

- 华为云账号
- Docker
- kubectl
- helm

## 快速开始

### 1. 创建基础设施

```bash
cd infra
terraform init
terraform plan
terraform apply
```

### 2. 构建镜像

```bash
docker build -t tak-server:latest .
docker push your-registry/tak-server:latest
```

### 3. 部署到 CCE

```bash
kubectl apply -f deployment.yaml
```

## 架构说明

```
客户端 → 云解析 DNS → 增强型ELB → CCE (TAK容器)
                                │
                ┌───────────────┼───────────────┐
                ▼               ▼               ▼
            GaussDB          SFS             OBS
```

详细架构说明请参考 [docs/architecture.md](docs/architecture.md)。

## 涉及云服务

- CCE (云容器引擎)
- GaussDB (云数据库)
- SFS (文件存储)
- 增强型ELB (负载均衡)
- OBS (对象存储)
- CSMS (密钥管理)
- 云解析 DNS

## 清理资源

```bash
kubectl delete -f deployment.yaml
terraform destroy
```

## 许可证

MIT No Attribution - Copyright (c) 2026 Huawei Cloud

## 联系方式

如有问题，请提交 Issue 或联系维护团队。
