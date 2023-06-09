# Virtual Network
resource "azurerm_virtual_network" "tf-7am-vnet" {
  name                = "tf-7am"
  location            = azurerm_resource_group.tf-7am-rg.location
  resource_group_name = azurerm_resource_group.tf-7am-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
  }
}

# Subnet
resource "azurerm_subnet" "tf-7am-sn" {
  name                 = "web-7am-subnet"
  resource_group_name  = azurerm_resource_group.tf-7am-rg.name
  virtual_network_name = azurerm_virtual_network.tf-7am-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "tf-7am-nsg" {
  name                = "tf-ssh-http"
  location            = azurerm_resource_group.tf-7am-rg.location
  resource_group_name = azurerm_resource_group.tf-7am-rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 510
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}

# Associate Subnet with NSG
resource "azurerm_subnet_network_security_group_association" "tf-7am-nsg-sn" {
  subnet_id                 = azurerm_subnet.tf-7am-sn.id
  network_security_group_id = azurerm_network_security_group.tf-7am-nsg.id
}

# Public IP
resource "azurerm_public_ip" "tf-7am-pip" {
  name                = "web-pip"
  resource_group_name = azurerm_resource_group.tf-7am-rg.name
  location            = azurerm_resource_group.tf-7am-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

# NIC
resource "azurerm_network_interface" "tf-7am-nic" {
  name                = "web-nic"
  location            = azurerm_resource_group.tf-7am-rg.location
  resource_group_name = azurerm_resource_group.tf-7am-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-7am-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-7am-pip.id
  }
}