#################################### Azure VNet, Subnet, NSG and Attachment of NSG to Subent #################################################

resource "azurerm_resource_group" "azure_resource_group" {
  name     = "${var.prefix}-resource-group"
  location = var.location
}

resource "azurerm_virtual_network" "threetier_vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name
}

resource "azurerm_subnet" "threetier_subnet" {
  name                 = "acctsub"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  virtual_network_name = azurerm_virtual_network.threetier_vnet.name
  address_prefixes     = ["10.10.1.0/24"]

}

resource "azurerm_subnet" "application_gateway_subnet" {
  name                 = "${var.prefix}-gateway-subnet"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  virtual_network_name = azurerm_virtual_network.threetier_vnet.name
  address_prefixes     = ["10.10.2.0/24"]

}

resource "azurerm_subnet" "mysql_flexible_server_subnet" {
  name                 = "${var.prefix}-mysql-flexible-server-subnet"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  virtual_network_name = azurerm_virtual_network.threetier_vnet.name
  address_prefixes     = ["10.10.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "postgresql_flexible_server_subnet" {
  name                 = "${var.prefix}-postgresql-flexible-server-subnet"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  virtual_network_name = azurerm_virtual_network.threetier_vnet.name
  address_prefixes     = ["10.10.4.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "postgres-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "appgtw_subnet" {
  name                 = "subnet-1"         ###"${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
#  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.Storage"]
  virtual_network_name = azurerm_virtual_network.threetier_vnet.name
  address_prefixes     = ["10.10.5.0/24"]
}

resource "azurerm_network_security_group" "threetier_nsg" {
  name                = "ssh_nsg"
  location            = azurerm_resource_group.azure_resource_group.location          
  resource_group_name = azurerm_resource_group.azure_resource_group.name         

  security_rule {
    name                       = "allow_ssh_http_https_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = [22, 80, 443]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "azure_nsg_sonarqube"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = azurerm_public_ip.public_ip_devopsagent.ip_address
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_nginx"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "10.10.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "rabbitmq1"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "25672"
    source_address_prefix      = "10.10.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "rabbitmq2"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5672"
    source_address_prefix      = "10.10.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "rabbitmq3"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4369"
    source_address_prefix      = "10.10.0.0/16"
    destination_address_prefix = "*"
  }

}

############# NSG has been created and attached to Subnet However It is also possible to create and attach a NSG at Network Interface (NIC) ###############

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association1" {
  subnet_id                 = azurerm_subnet.threetier_subnet.id
  network_security_group_id = azurerm_network_security_group.threetier_nsg.id
}
