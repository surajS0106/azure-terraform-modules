# Core VM Configuration
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "os_type" {
  description = "Operating system type - Linux or Windows"
  type        = string
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either 'Linux' or 'Windows'."
  }
}

# Admin Configuration
variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Administrator password for Windows VMs"
  type        = string
  default     = null
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for Linux VMs"
  type        = string
  default     = null
}

variable "disable_password_authentication" {
  description = "Disable password authentication for Linux VMs"
  type        = bool
  default     = true
}

# Network Configuration
variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "create_public_ip" {
  description = "Whether to create a public IP for the VM"
  type        = bool
  default     = false
}

variable "public_ip_allocation_method" {
  description = "Allocation method for the public IP"
  type        = string
  default     = "Static"
  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "Public IP allocation method must be either 'Static' or 'Dynamic'."
  }
}

variable "public_ip_sku" {
  description = "SKU for the public IP"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "Public IP SKU must be either 'Basic' or 'Standard'."
  }
}

variable "private_ip_allocation_method" {
  description = "Private IP allocation method"
  type        = string
  default     = "Dynamic"
  validation {
    condition     = contains(["Static", "Dynamic"], var.private_ip_allocation_method)
    error_message = "Private IP allocation method must be either 'Static' or 'Dynamic'."
  }
}

variable "private_ip_address" {
  description = "Static private IP address (required if allocation method is Static)"
  type        = string
  default     = null
}

# Security Configuration
variable "allow_http_traffic" {
  description = "Allow HTTP traffic (port 80)"
  type        = bool
  default     = false
}

variable "allow_https_traffic" {
  description = "Allow HTTPS traffic (port 443)"
  type        = bool
  default     = false
}

# Storage Configuration
variable "os_disk_caching" {
  description = "Caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "OS disk caching must be 'None', 'ReadOnly', or 'ReadWrite'."
  }
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Premium_LRS"
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_storage_account_type)
    error_message = "OS disk storage type must be 'Standard_LRS', 'StandardSSD_LRS', or 'Premium_LRS'."
  }
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = null
}

variable "data_disks" {
  description = "List of data disks to attach to the VM"
  type = list(object({
    disk_size_gb         = number
    storage_account_type = string
    caching              = string
  }))
  default = []
}

# Image Configuration
variable "source_image_reference" {
  description = "Source image reference for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

# Diagnostics Configuration
variable "enable_boot_diagnostics" {
  description = "Enable boot diagnostics for the VM"
  type        = bool
  default     = true
}

# Extensions Configuration
variable "custom_script_extension" {
  description = "Custom script to run on the VM"
  type        = string
  default     = null
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
