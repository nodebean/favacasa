# terraform-proxmox-talos

## Installation

1. Add the Proxmox root user credentials to your environment:
   ```bash
   export PROXMOX_VE_USERNAME="root@pve"
   export PROXMOX_VE_PASSWORD="some-password"
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```
