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

