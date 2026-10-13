# 架构说明: 无服务器 TAK Server 华为云方案

## 1. 方案概述

本方案展示如何在华为云上部署无服务器 TAK Server (Team Awareness Kit)，实现高可用、自动扩展且成本优化的协作平台。

TAK 是一种情境感知和地理空间协作软件，最初为军事行动创建，现已广泛应用于应急管理、灾害响应、执法和搜救行动。

## 2. 架构设计

### 2.1 整体架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        客户端层                          │
│                                                           │
│    ┌──────────────┐    ┌──────────────────────┐        │
│    │ ATAK 移动设备 │    │ iTAK 移动设备       │        │
│    └──────────────┘    └──────────────────────┘        │
└───────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        网络层                              │
│                                                           │
│  ┌─────────────────┐    ┌─────────────────────────────┐     │
│  │ 云解析 DNS      │    │ 增强型 ELB                │     │
│  │ (域名解析)     │    │ (TAK 协议负载均衡)        │     │
│  └─────────────────┘    └───────────┬─────────────┘     │
│                                      │                     │
└──────────────────────────────────────┼──────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                        计算层                              │
│                                                           │
│  ┌─────────────────┐    ┌─────────────────────────────┐     │
│  │ CCE 集群        │    │ CCE 节点池                │     │
│  │ (TAK 容器)     │    │ (自动扩展)               │     │
│  └─────────────────┘    └─────────────────────────────┘     │
│           │                                                    │
└───────────┼────────────────────────────────────────────────┘
            │
    ┌───────┴───────┐
    │               │
    ▼               ▼
┌─────────────┐ ┌─────────────┐
│ GaussDB     │ │ SFS         │
│ (数据库)   │ │ (文件存储)  │
└─────────────┘ └─────────────┘
    │               │
    ▼               ▼
┌─────────────┐ ┌─────────────┐
│ CSMS        │ │ OBS         │
│ (密钥管理)  │ │ (对象存储)  │
└─────────────┘ └─────────────┘
```

### 2.2 核心组件

| 组件 | 说明 |
|------|------|
| **CCE** | 云容器引擎，无服务器容器计算 |
| **GaussDB** | 企业级 PostgreSQL 兼容数据库 |
| **SFS** | 弹性文件存储，TAK 配置持久化 |
| **增强型ELB** | 高性能负载均衡，支持 TCP/UDP |
| **CSMS** | 密钥管理服务，安全存储凭证 |
| **OBS** | 对象存储，证书和数据存储 |
| **云解析 DNS** | 域名解析服务 |

## 3. 数据流程

### 3.1 用户访问流程

```
用户设备 (ATAK/iTAK)
     │
     ▼
云解析 DNS (tak.domain.com)
     │
     ▼
增强型 ELB (TCP/UDP 负载均衡)
     │
     ▼
CCE Pod (TAK Server 容器)
     │
     ├──▶ GaussDB (数据存储)
     ├──▶ SFS (配置文件)
     └──▶ OBS (静态资源)
```

### 3.2 TAK 协议

TAK 使用以下端口和协议：
- **ATAK 客户端**: 端口 8089/8443 (HTTPS)
- **CoT (Cursor on Target)**: XML 格式的位置和状态数据
- **TAK 协议**: 支持任务管理、地图共享等功能

## 4. 技术细节

### 4.1 CCE 部署配置

```yaml
# CCE Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tak-server
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tak-server
  template:
    metadata:
      labels:
        app: tak-server
    spec:
      containers:
      - name: tak-server
        image: tak-server:latest
        ports:
        - containerPort: 8089
        - containerPort: 8443
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "2000m"
            memory: "4Gi"
```

### 4.2 GaussDB 连接

TAK Server 需要 PostgreSQL 数据库连接：

```python
# 数据库连接配置
DB_HOST = "gaussdb.internal.example.com"
DB_PORT = 5432
DB_NAME = "takdb"
DB_USER = "takuser"
```

### 4.3 SFS 挂载

TAK 配置需要持久化存储：

```yaml
# PVC 配置
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: tak-config
spec:
  accessModes:
    - ReadWriteMany
  storageClassName:efs
  resources:
    requests:
      storage: 10Gi
```

## 5. 限制说明

- TAK Server 需要构建 Docker 镜像
- GaussDB 语法与 MySQL/PostgreSQL 有细微差异
- CCE 自动扩展配置需要根据业务调整
