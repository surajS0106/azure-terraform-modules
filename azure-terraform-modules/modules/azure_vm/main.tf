# Azure Virtual Machine Module
# This module creates an Azure VM with associated resources

# Public IP (optional)
resource "azurerm_public_ip" "this" {
  count               = var.create_public_ip ? 1 : 0
  name                = "${var.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku

  tags = var.tags
}

# Network Security Group
resource "azurerm_network_security_group" "this" {
  name                = "${var.vm_name}-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Security Rules
resource "azurerm_network_security_rule" "ssh" {
  count                       = var.os_type == "Linux" ? 1 : 0
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "rdp" {
  count                       = var.os_type == "Windows" ? 1 : 0
  name                        = "RDP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "http" {
  count                       = var.allow_http_traffic ? 1 : 0
  name                        = "HTTP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "https" {
  count                       = var.allow_https_traffic ? 1 : 0
  name                        = "HTTPS"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

# Network Interface
resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_allocation_method
    private_ip_address            = var.private_ip_allocation_method == "Static" ? var.private_ip_address : null
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.this[0].id : null
  }

  tags = var.tags
}

# Associate Network Security Group to Network Interface
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# Storage Account for Boot Diagnostics (optional)
resource "azurerm_storage_account" "boot_diagnostics" {
  count                    = var.enable_boot_diagnostics ? 1 : 0
  name                     = "${lower(replace(var.vm_name, "-", ""))}bootdiag${random_string.storage_suffix[0].result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "random_string" "storage_suffix" {
  count   = var.enable_boot_diagnostics ? 1 : 0
  length  = 6
  special = false
  upper   = false
}

# Managed Disk (optional additional data disks)
resource "azurerm_managed_disk" "data_disk" {
  count                = length(var.data_disks)
  name                 = "${var.vm_name}-datadisk-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = var.data_disks[count.index].storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disks[count.index].disk_size_gb

  tags = var.tags
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "this" {
  count                           = var.os_type == "Linux" ? 1 : 0
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.ssh_public_key == null ? var.admin_password : null
  disable_password_authentication = var.ssh_public_key != null ? var.disable_password_authentication : false

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key
    }
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = azurerm_storage_account.boot_diagnostics[0].primary_blob_endpoint
    }
  }

  tags = var.tags
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "this" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = azurerm_storage_account.boot_diagnostics[0].primary_blob_endpoint
    }
  }

  tags = var.tags
}

# Virtual Machine Data Disk Attachment
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  count              = length(var.data_disks)
  managed_disk_id    = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
  lun                = count.index
  caching            = var.data_disks[count.index].caching
}

# Virtual Machine Extension for Custom Script (optional)
resource "azurerm_virtual_machine_extension" "custom_script" {
  count                = var.custom_script_extension != null ? 1 : 0
  name                 = "CustomScriptExtension"
  virtual_machine_id   = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
  publisher            = var.os_type == "Linux" ? "Microsoft.Azure.Extensions" : "Microsoft.Compute"
  type                 = var.os_type == "Linux" ? "CustomScript" : "CustomScriptExtension"
  type_handler_version = var.os_type == "Linux" ? "2.0" : "1.10"

  settings = jsonencode({
    script = base64encode(var.custom_script_extension)
  })

  tags = var.tags
}
