# OpenWebUI on Azure Container Apps

Terraform configuration to deploy [OpenWebUI](https://github.com/open-webui/open-webui) on Azure Container Apps with persistent storage.

> ℹ️ This is a Terraform implementation of the guide: [Deploy OpenWebUI on Azure Container Apps](https://blakedrumm.com/blog/azure-container-apps-openweb-ui/#6-link-azure-files-to-container-apps-environment) (which uses Azure Portal)

## Key Configuration

- **Scaling**: Fixed to 1 replica (required for stability)

  ```hcl
  min_replicas = 1
  max_replicas = 1
  ```

- **Storage**: Azure File Share with required mount options
  ```hcl
  mount_options = "nobrl"  # Required for proper file locking
  ```

## Prerequisites

- Azure CLI ([install](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
- Terraform >= 1.0.0
- Azure subscription

## Quick Start

1. Clone and enter the repository:

   ```bash
   git clone https://github.com/yourusername/azure-openwebui-infra.git
   cd azure-openwebui-infra
   ```

2. Configure your Azure credentials:

   ```bash
   az login
   ```

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Deploy:
   ```bash
   terraform apply
   ```

## Important Notes

- The application requires exactly 1 replica for stable operation
- Persistent storage uses Azure File Share with `nobrl` mount option for compatibility
- Default configuration includes HTTPS with Let's Encrypt

## Configuration

Customize your deployment by editing these variables in `variables.tf` or creating a `terraform.tfvars` file:

```hcl
location = "northeurope"          # Azure region
container_app_name = "openwebui"  # Name for your container app
container_image = "ghcr.io/open-webui/open-webui:main"  # Version to deploy
```

Key configuration options:

- `location`: Azure region (default: "northeurope")
- `resource_group_name`: Name for the resource group
- `container_app_name`: Name for the Container App
- `container_image`: Docker image to use
- `target_port`: Port the application listens on (default: 8080)

## Clean Up

To remove all resources:

```bash
terraform destroy
```

## License

[MIT](LICENSE) - Feel free to use and modify this configuration for your needs.
