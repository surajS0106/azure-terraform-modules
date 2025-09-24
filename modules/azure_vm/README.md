# Azure Virtual Machine Module

This module creates an Azure Virtual Machine with all associated resources including networking, security, and storage components.

## Features

- **Dual OS Support**: Creates either Linux or Windows VMs based on configuration
- **Network Security**: Automatic NSG creation with configurable security rules
- **Public IP**: Optional public IP address with static or dynamic allocation
- **Data Disks**: Support for multiple data disks with configurable storage types
- **Boot Diagnostics**: Optional boot diagnostics with dedicated storage account
- **Custom Extensions**: Support for custom script extensions
- **Security**: SSH key authentication for Linux, password authentication for Windows

## Resources Created

### Core Resources

- `azurerm_linux_virtual_machine` or `azurerm_windows_virtual_machine` - Virtual Machine
- `azurerm_network_interface` - Network Interface
- `azurerm_network_security_group` - Network Security Group with rules
- `azurerm_network_interface_security_group_association` - NSG association

### Optional Resources

- `azurerm_public_ip` - Public IP address (if enabled)
- `azurerm_storage_account` - Boot diagnostics storage (if enabled)
- `azurerm_managed_disk` - Additional data disks (if specified)
- `azurerm_virtual_machine_data_disk_attachment` - Data disk attachments
- `azurerm_virtual_machine_extension` - Custom script extension (if specified)

## Usage Examples

### Linux VM with SSH Key

```hcl
module "linux_vm" {
  source = "./modules/azure_vm"

  vm_name             = "my-linux-vm"
  resource_group_name = "my-rg"
  location           = "East US"
  subnet_id          = module.vnet.subnet_ids["vm-subnet"]

  os_type        = "Linux"
  vm_size        = "Standard_B2s"
  admin_username = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")

  create_public_ip     = true
  allow_http_traffic   = true
  allow_https_traffic  = true

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  data_disks = [
    {
      disk_size_gb         = 100
      storage_account_type = "Premium_LRS"
      caching              = "ReadWrite"
    }
  ]

  tags = {
    Environment = "Production"
    Owner       = "DevOps Team"
  }
}
```

### Windows VM with RDP Access

```hcl
module "windows_vm" {
  source = "./modules/azure_vm"

  vm_name             = "my-windows-vm"
  resource_group_name = "my-rg"
  location           = "East US"
  subnet_id          = module.vnet.subnet_ids["vm-subnet"]

  os_type        = "Windows"
  vm_size        = "Standard_D2s_v3"
  admin_username = "adminuser"
  admin_password = "SecurePassword123!"

  create_public_ip = true

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  enable_boot_diagnostics = true

  custom_script_extension = <<-EOT
    Write-Host "Installing IIS..."
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    Write-Host "IIS installation completed."
  EOT

  tags = {
    Environment = "Development"
    Application = "WebServer"
  }
}
```

### High-Performance VM with Multiple Data Disks

```hcl
module "high_perf_vm" {
  source = "./modules/azure_vm"

  vm_name             = "database-server"
  resource_group_name = "production-rg"
  location           = "East US"
  subnet_id          = module.vnet.subnet_ids["database-subnet"]

  os_type        = "Linux"
  vm_size        = "Standard_E4s_v3"
  admin_username = "dbadmin"
  ssh_public_key = file("~/.ssh/id_rsa.pub")

  # Private VM without public IP
  create_public_ip = false

  # Static private IP
  private_ip_allocation_method = "Static"
  private_ip_address          = "10.0.1.100"

  # Premium OS disk
  os_disk_storage_account_type = "Premium_LRS"
  os_disk_size_gb             = 128

  # Multiple data disks for database
  data_disks = [
    {
      disk_size_gb         = 500
      storage_account_type = "Premium_LRS"
      caching              = "None"
    },
    {
      disk_size_gb         = 1000
      storage_account_type = "Premium_LRS"
      caching              = "ReadOnly"
    }
  ]

  tags = {
    Environment = "Production"
    Role        = "Database"
    Backup      = "Required"
  }
}
```

## Variables

| Name                            | Description                                    | Type           | Default          | Required |
| ------------------------------- | ---------------------------------------------- | -------------- | ---------------- | :------: |
| vm_name                         | Name of the virtual machine                    | `string`       | n/a              |   yes    |
| resource_group_name             | Name of the resource group                     | `string`       | n/a              |   yes    |
| location                        | Azure region where resources will be created   | `string`       | n/a              |   yes    |
| subnet_id                       | ID of the subnet where the VM will be deployed | `string`       | n/a              |   yes    |
| os_type                         | Operating system type - Linux or Windows       | `string`       | n/a              |   yes    |
| vm_size                         | Size of the virtual machine                    | `string`       | `"Standard_B2s"` |    no    |
| admin_username                  | Administrator username for the VM              | `string`       | `"azureuser"`    |    no    |
| admin_password                  | Administrator password for Windows VMs         | `string`       | `null`           |    no    |
| ssh_public_key                  | SSH public key for Linux VMs                   | `string`       | `null`           |    no    |
| disable_password_authentication | Disable password authentication for Linux VMs  | `bool`         | `true`           |    no    |
| create_public_ip                | Whether to create a public IP for the VM       | `bool`         | `false`          |    no    |
| public_ip_allocation_method     | Allocation method for the public IP            | `string`       | `"Static"`       |    no    |
| public_ip_sku                   | SKU for the public IP                          | `string`       | `"Standard"`     |    no    |
| private_ip_allocation_method    | Private IP allocation method                   | `string`       | `"Dynamic"`      |    no    |
| private_ip_address              | Static private IP address                      | `string`       | `null`           |    no    |
| allow_http_traffic              | Allow HTTP traffic (port 80)                   | `bool`         | `false`          |    no    |
| allow_https_traffic             | Allow HTTPS traffic (port 443)                 | `bool`         | `false`          |    no    |
| os_disk_caching                 | Caching type for the OS disk                   | `string`       | `"ReadWrite"`    |    no    |
| os_disk_storage_account_type    | Storage account type for the OS disk           | `string`       | `"Premium_LRS"`  |    no    |
| os_disk_size_gb                 | Size of the OS disk in GB                      | `number`       | `null`           |    no    |
| data_disks                      | List of data disks to attach to the VM         | `list(object)` | `[]`             |    no    |
| source_image_reference          | Source image reference for the VM              | `object`       | Ubuntu 20.04 LTS |    no    |
| enable_boot_diagnostics         | Enable boot diagnostics for the VM             | `bool`         | `true`           |    no    |
| custom_script_extension         | Custom script to run on the VM                 | `string`       | `null`           |    no    |
| tags                            | Tags to apply to all resources                 | `map(string)`  | `{}`             |    no    |

## Outputs

| Name                                  | Description                                        |
| ------------------------------------- | -------------------------------------------------- |
| vm_id                                 | ID of the virtual machine                          |
| vm_name                               | Name of the virtual machine                        |
| vm_private_ip                         | Private IP address of the virtual machine          |
| vm_public_ip                          | Public IP address of the virtual machine           |
| vm_fqdn                               | Fully qualified domain name of the virtual machine |
| network_interface_id                  | ID of the network interface                        |
| network_security_group_id             | ID of the network security group                   |
| public_ip_id                          | ID of the public IP                                |
| ssh_connection_command                | SSH connection command for Linux VMs               |
| rdp_connection_info                   | RDP connection information for Windows VMs         |
| data_disk_ids                         | IDs of the data disks                              |
| boot_diagnostics_storage_account_name | Name of boot diagnostics storage account           |

## Data Disk Configuration

The `data_disks` variable accepts a list of objects with the following structure:

```hcl
data_disks = [
  {
    disk_size_gb         = 100                    # Size in GB
    storage_account_type = "Premium_LRS"          # Standard_LRS, StandardSSD_LRS, Premium_LRS
    caching              = "ReadWrite"            # None, ReadOnly, ReadWrite
  }
]
```

## Common VM Sizes

| Size            | vCPUs | RAM   | Temp Storage | Use Case            |
| --------------- | ----- | ----- | ------------ | ------------------- |
| Standard_B1s    | 1     | 1 GB  | 4 GB         | Light workloads     |
| Standard_B2s    | 2     | 4 GB  | 8 GB         | Small applications  |
| Standard_D2s_v3 | 2     | 8 GB  | 16 GB        | General purpose     |
| Standard_D4s_v3 | 4     | 16 GB | 32 GB        | Medium applications |
| Standard_E4s_v3 | 4     | 32 GB | 64 GB        | Memory optimized    |
| Standard_F4s_v2 | 4     | 8 GB  | 32 GB        | Compute optimized   |

## Common Image References

### Linux Images

```hcl
# Ubuntu 20.04 LTS
source_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts-gen2"
  version   = "latest"
}

# CentOS 8
source_image_reference = {
  publisher = "OpenLogic"
  offer     = "CentOS"
  sku       = "8_5-gen2"
  version   = "latest"
}

# Red Hat Enterprise Linux 8
source_image_reference = {
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "8-LVM-gen2"
  version   = "latest"
}
```

### Windows Images

```hcl
# Windows Server 2022 Datacenter
source_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-Datacenter"
  version   = "latest"
}

# Windows 11 Pro
source_image_reference = {
  publisher = "MicrosoftWindowsDesktop"
  offer     = "Windows-11"
  sku       = "win11-22h2-pro"
  version   = "latest"
}
```

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.12.1 |
| azurerm   | >= 4.0.0  |
| random    | >= 3.0.0  |

## Security Considerations

1. **SSH Keys**: For Linux VMs, always use SSH key authentication instead of passwords
2. **Network Security**: The module creates NSG rules for SSH/RDP - consider restricting source IP ranges
3. **Public IPs**: Only create public IPs when necessary; use private IPs with bastion hosts when possible
4. **Disk Encryption**: Consider enabling Azure Disk Encryption for sensitive workloads
5. **Boot Diagnostics**: Storage account for boot diagnostics uses LRS - consider upgrading for production

## Troubleshooting

### Common Issues

1. **SSH Key Format**: Ensure SSH public key is in OpenSSH format
2. **VM Size Availability**: Some VM sizes may not be available in all regions
3. **Disk Size Limits**: OS disk size depends on the base image
4. **Network Security**: Verify NSG rules allow required traffic

### Debugging Commands

```bash
# Check VM status
az vm show --resource-group <rg-name> --name <vm-name> --show-details

# Get VM public IP
az vm show --resource-group <rg-name> --name <vm-name> -d --query publicIps -o tsv

# Check NSG rules
az network nsg show --resource-group <rg-name> --name <nsg-name>
```

## License

This module is licensed under the MIT License.
