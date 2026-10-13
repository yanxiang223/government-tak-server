# Serverless TAK Server on Huawei Cloud

![License](https://img.shields.io/badge/License-MIT-green)

## Overview

This solution demonstrates how to deploy a serverless TAK Server (Team Awareness Kit) on Huawei Cloud, achieving high availability, auto-scaling, and cost-optimized collaboration platform.

TAK is a situational awareness and geospatial collaboration software, originally created for military operations and now widely used in emergency management, disaster response, law enforcement, and search and rescue operations.

### Core Features

- **Serverless Architecture**: Auto-scaling compute and database resources
- **High Availability**: Multi-AZ deployment
- **Cost Optimization**: Pay-as-you-go, auto-scale to zero
- **Enhanced Security**: Network isolation and secret management

## Prerequisites

- Huawei Cloud account
- Docker
- kubectl
- helm

## Quick Start

### 1. Create Infrastructure

```bash
cd infra
terraform init
terraform plan
terraform apply
```

### 2. Build Image

```bash
docker build -t tak-server:latest .
docker push your-registry/tak-server:latest
```

### 3. Deploy to CCE

```bash
kubectl apply -f deployment.yaml
```

## Architecture

```
Client → Cloud DNS → Enhanced ELB → CCE (TAK Container)
                                │
                ┌───────────────┼───────────────┐
                ▼               ▼               ▼
            GaussDB          SFS             OBS
```

See [docs/architecture.md](docs/architecture.md) for detailed architecture.

## Cloud Services

- CCE (Cloud Container Engine)
- GaussDB (Cloud Database)
- SFS (File Storage)
- Enhanced ELB (Load Balancer)
- OBS (Object Storage)
- CSMS (Secret Management)
- Cloud DNS

## Cleanup

```bash
kubectl delete -f deployment.yaml
terraform destroy
```

## License

MIT No Attribution - Copyright (c) 2026 Huawei Cloud

## Contact

For issues, please submit an Issue or contact the maintenance team.
