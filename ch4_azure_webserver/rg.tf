resource "azurerm_resource_group" "main" {
  name     = "${var.resource_name}_rg"
  location = var.main_locaiton

  tags = {
    Name = var.resource_name
  }
}