# Create a resource group
resource "azurerm_resource_group" "tf-7am-rg" {
  name     = "az-tf-rg"
  location = "East US"
  tags = {
    environment = "dev"
  }
}
