# Voting App Helm Chart

## Overview

This Helm chart deploys the Voting App, a sample application with frontend, API, and MongoDB components.

## Prerequisites

- Kubernetes cluster with Helm installed
- RBAC permissions for Helm service account

## Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd voting-app

   helm install voting-app .
   ```
# Configuration

The default configuration is provided in the `values.yaml` file. You can override these values by creating a custom `values.yaml` file and using it during installation:

```bash
helm install voting-app -f custom-values.yaml .
```
# Charts, Values, and Templates

## Charts:

- The root directory contains a `Chart.yaml` file, which serves as the main chart.

## Values:

- The `values.yaml` file defines default configurations for each component.

## Templates:

- The `templates` directory contains YAML files with Helm template variables used for Kubernetes resource definitions.


## Important Values

### Frontend:
- `replicaCount`: Number of frontend replicas.
- `image.repository`: Frontend Docker image repository.
- `image.tag`: Frontend Docker image tag.
- `service.type`: Service type for frontend (LoadBalancer).

### API:
- `replicaCount`: Number of API replicas.
- `image.repository`: API Docker image repository.
- `image.tag`: API Docker image tag.
- `service.type`: Service type for API (LoadBalancer).

### MongoDB:
- `replicaCount`: Number of MongoDB replicas.
- `image.repository`: MongoDB Docker image repository.
- `image.tag`: MongoDB Docker image tag.
- `service.type`: Service type for MongoDB (ClusterIP).
