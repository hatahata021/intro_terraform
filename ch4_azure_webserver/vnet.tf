resource "azurerm_virtual_network" "main" {
  name     = "${var.employee_number}_vnet"
  location = var.main_locaiton

  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Name = var.employee_number
  }

}

resource "azurerm_subnet" "public_main" {
  name = "${var.employee_number}_subnet"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = [ "10.0.1.0/24" ]
}