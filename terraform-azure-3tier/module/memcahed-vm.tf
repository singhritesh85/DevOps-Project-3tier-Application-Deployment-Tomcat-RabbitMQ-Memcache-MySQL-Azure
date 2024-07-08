############################################## Creation for NSG for Memcached Server #######################################################

resource "azurerm_network_security_group" "azure_nsg_memcached" {
#  count               = var.vm_count_memcached
  name                = "memcached-nsg"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  security_rule {
    name                       = "memcached_ssh_azure"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "memcached"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "11211"
    source_address_prefix      = "10.224.0.0/12"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }
}

########################################## Create Public IP and Network Interface for Memcached Server #############################################

resource "azurerm_public_ip" "public_ip_memcached" {
  count               = var.vm_count_memcached
  name                = "memcached-ip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }
}

resource "azurerm_network_interface" "vnet_interface_memcached" {
  count               = var.vm_count_memcached
  name                = "memcached-nic-${count.index + 1}"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  ip_configuration {
    name                          = "memcached-ip-configuration-${count.index + 1}"
    subnet_id                     = azurerm_subnet.threetier_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip_memcached[count.index].id
  }

  tags = {
    environment = var.env
  }
}

############################################ Attach NSG to Network Interface for Memcached Server #####################################################

resource "azurerm_network_interface_security_group_association" "nsg_nic_memcached" {
  count                     = var.vm_count_memcached
  network_interface_id      = azurerm_network_interface.vnet_interface_memcached[count.index].id
  network_security_group_id = azurerm_network_security_group.azure_nsg_memcached.id

}

######################################################## Create Azure VM for Memcached Server ##########################################################

resource "azurerm_linux_virtual_machine" "azure_vm_memcached" {
  count                 = var.vm_count_memcached
  name                  = "memcached-vm-${count.index + 1}"
  location              = azurerm_resource_group.azure_resource_group.location
  resource_group_name   = azurerm_resource_group.azure_resource_group.name
  network_interface_ids = [azurerm_network_interface.vnet_interface_memcached[count.index].id]
  size                  = var.vm_size
  zone                 = var.availability_zone[0]
  computer_name  = "memcached-vm-${count.index + 1}"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = filebase64("custom_data_memcached.sh")
  disable_password_authentication = false

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    storage_account_uri  = ""
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
  os_disk {
    name              = "memcached-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_managed_disk" "disk_memcached" {
  count                = var.vm_count_memcached
  name                 = "memcached-datadisk-${count.index + 1}"
  location             = azurerm_resource_group.azure_resource_group.location
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  zone                 = var.availability_zone[0]
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.extra_disk_size_gb
}


resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment_memcached" {
  count              = var.vm_count_memcached
  managed_disk_id    = azurerm_managed_disk.disk_memcached[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_vm_memcached[count.index].id
  lun                ="0"
  caching            = "ReadWrite"
}
