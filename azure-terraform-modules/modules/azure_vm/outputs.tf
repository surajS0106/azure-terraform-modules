# Virtual Machine Outputs
output "vm_id" {
  description = "ID of the virtual machine"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = var.vm_name
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.this.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine (if created)"
  value       = var.create_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

output "vm_fqdn" {
  description = "Fully qualified domain name of the virtual machine (if public IP created)"
  value       = var.create_public_ip ? azurerm_public_ip.this[0].fqdn : null
}

# Network Interface Outputs
output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.this.id
}

output "network_interface_private_ip" {
  description = "Private IP address of the network interface"
  value       = azurerm_network_interface.this.private_ip_address
}

# Network Security Group Outputs
output "network_security_group_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.this.id
}

output "network_security_group_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.this.name
}

# Public IP Outputs
output "public_ip_id" {
  description = "ID of the public IP (if created)"
  value       = var.create_public_ip ? azurerm_public_ip.this[0].id : null
}

output "public_ip_address" {
  description = "Public IP address (if created)"
  value       = var.create_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

# Storage Outputs
output "boot_diagnostics_storage_account_name" {
  description = "Name of the boot diagnostics storage account (if created)"
  value       = var.enable_boot_diagnostics ? azurerm_storage_account.boot_diagnostics[0].name : null
}

output "boot_diagnostics_storage_account_uri" {
  description = "URI of the boot diagnostics storage account (if created)"
  value       = var.enable_boot_diagnostics ? azurerm_storage_account.boot_diagnostics[0].primary_blob_endpoint : null
}

# Data Disk Outputs
output "data_disk_ids" {
  description = "IDs of the data disks"
  value       = azurerm_managed_disk.data_disk[*].id
}

output "data_disk_names" {
  description = "Names of the data disks"
  value       = azurerm_managed_disk.data_disk[*].name
}

# VM Details
output "vm_size" {
  description = "Size of the virtual machine"
  value       = var.vm_size
}

output "vm_os_type" {
  description = "Operating system type of the virtual machine"
  value       = var.os_type
}

output "vm_admin_username" {
  description = "Administrator username of the virtual machine"
  value       = var.admin_username
}

# Connection Information
output "ssh_connection_command" {
  description = "SSH connection command for Linux VMs (if public IP exists)"
  value       = var.os_type == "Linux" && var.create_public_ip ? "ssh ${var.admin_username}@${azurerm_public_ip.this[0].ip_address}" : null
}

output "rdp_connection_info" {
  description = "RDP connection information for Windows VMs (if public IP exists)"
  value = var.os_type == "Windows" && var.create_public_ip ? {
    ip_address = azurerm_public_ip.this[0].ip_address
    username   = var.admin_username
    port       = 3389
  } : null
}
