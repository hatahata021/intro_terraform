resource "azurerm_resource_group" "main" {
  name     = "${var.employee_number}_rg"
  location = var.main_locaiton

  tags = {
    Name = var.employee_number
  }
}