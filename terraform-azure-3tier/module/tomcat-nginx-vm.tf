############################################## Creation for NSG for Tomcat Server #######################################################

resource "azurerm_network_security_group" "azure_nsg_tomcat" {
#  count               = var.vm_count
  name                = "tomcat-nsg"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  security_rule {
    name                       = "tomcat_ssh_azure"
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
    name                       = "tomcat2"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "10.10.0.0/16"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }
}

########################################## Create Public IP and Network Interface for Tomcat Server #############################################

resource "azurerm_public_ip" "public_ip_tomcat" {
#  count               = var.vm_count
  name                = "tomcat-ip"             ###"tomcat-ip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }
}

resource "azurerm_network_interface" "vnet_interface_tomcat" {
#  count               = var.vm_count
  name                = "tomcat-nic"          ###"tomcat-nic-${count.index + 1}"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  ip_configuration {
    name                          = "tomcat-ip-configuration"         ###"tomcat-ip-configuration-${count.index + 1}"
    subnet_id                     = azurerm_subnet.threetier_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip_tomcat.id      ###azurerm_public_ip.public_ip_tomcat[count.index].id
  }

  tags = {
    environment = var.env
  }
}

############################################ Attach NSG to Network Interface for Tomcat Server #####################################################

resource "azurerm_network_interface_security_group_association" "nsg_nic_tomcat" {
#  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.vnet_interface_tomcat.id      ###azurerm_network_interface.vnet_interface_tomcat[count.index].id
  network_security_group_id = azurerm_network_security_group.azure_nsg_tomcat.id

}

######################################################## Create Azure VM for Tomcat Server ##########################################################

resource "azurerm_linux_virtual_machine" "azure_vm_tomcat" {
#  count                 = var.vm_count
  name                  = "tomcat-vm"                ###"tomcat-vm-${count.index + 1}"
  location              = azurerm_resource_group.azure_resource_group.location
  resource_group_name   = azurerm_resource_group.azure_resource_group.name
  network_interface_ids = [azurerm_network_interface.vnet_interface_tomcat.id]     ###[azurerm_network_interface.vnet_interface_tomcat[count.index].id]
  size                  = var.vm_size
  zone                 = var.availability_zone[0]
  computer_name  = "tomcat-vm"                       ###"tomcat-vm-${count.index + 1}"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = filebase64("custom_data_tomcat.sh")
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
    name              = "tomcat-osdisk"              ###"tomcat-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_managed_disk" "disk_tomcat" {
#  count                = var.vm_count
  name                 = "tomcat-datadisk"          ###"tomcat-datadisk-${count.index + 1}"
  location             = azurerm_resource_group.azure_resource_group.location
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  zone                 = var.availability_zone[0]
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.extra_disk_size_gb
}


resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment_tomcat" {
#  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.disk_tomcat.id                                 ###azurerm_managed_disk.disk_tomcat[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_vm_tomcat.id       ###azurerm_linux_virtual_machine.azure_vm_tomcat[count.index].id
  lun                ="0"
  caching            = "ReadWrite"
}

############################################## Creation for NSG for Nginx Server #######################################################

resource "azurerm_network_security_group" "azure_nsg_nginx" {
#  count               = var.vm_count_nginx
  name                = "nginx-nsg"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  security_rule {
    name                       = "nginx_ssh_azure"
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
    name                       = "nginx"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }
}

########################################## Create Public IP and Network Interface for Nginx Server #############################################

resource "azurerm_public_ip" "public_ip_nginx" {
#  count               = var.vm_count_nginx
  name                = "nginx-ip"                ####"nginx-ip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }
}

resource "azurerm_network_interface" "vnet_interface_nginx" {
#  count               = var.vm_count_nginx
  name                = "nginx-nic"           ###"nginx-nic-${count.index + 1}"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  ip_configuration {
    name                          = "nginx-ip-configuration"             ###"nginx-ip-configuration-${count.index + 1}"
    subnet_id                     = azurerm_subnet.threetier_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip_nginx.id          ###azurerm_public_ip.public_ip_nginx[count.index].id
  }

  tags = {
    environment = var.env
  }
}

############################################ Attach NSG to Network Interface for Nginx Server #####################################################

resource "azurerm_network_interface_security_group_association" "nsg_nic_nginx" {
#  count                     = var.vm_count_nginx
  network_interface_id      = azurerm_network_interface.vnet_interface_nginx.id     ###azurerm_network_interface.vnet_interface_nginx[count.index].id
  network_security_group_id = azurerm_network_security_group.azure_nsg_nginx.id

}

######################################################## Create Azure VM for Nginx Server ##########################################################

resource "azurerm_linux_virtual_machine" "azure_vm_nginx" {
#  count                 = var.vm_count_nginx
  name                  = "nginx-vm"             ###"nginx-vm-${count.index + 1}"
  location              = azurerm_resource_group.azure_resource_group.location
  resource_group_name   = azurerm_resource_group.azure_resource_group.name
  network_interface_ids = [azurerm_network_interface.vnet_interface_nginx.id]   ###[azurerm_network_interface.vnet_interface_nginx[count.index].id]
  size                  = var.vm_size
  zone                 = var.availability_zone[0]
  computer_name  = "nginx-vm"                     ###"nginx-vm-${count.index + 1}"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = filebase64("custom_data_nginx.sh")
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
    name              = "nginx-osdisk"             ###"nginx-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_managed_disk" "disk_nginx" {
#  count                = var.vm_count_nginx
  name                 = "nginx-datadisk"           ###"nginx-datadisk-${count.index + 1}"
  location             = azurerm_resource_group.azure_resource_group.location
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  zone                 = var.availability_zone[0]
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.extra_disk_size_gb
}


resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment_nginx" {
#  count              = var.vm_count_nginx
  managed_disk_id    = azurerm_managed_disk.disk_nginx.id                  ###azurerm_managed_disk.disk_nginx[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_vm_nginx.id     ###azurerm_linux_virtual_machine.azure_vm_nginx[count.index].id
  lun                ="0"
  caching            = "ReadWrite"
}
