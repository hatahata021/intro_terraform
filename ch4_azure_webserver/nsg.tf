resource "azurerm_network_security_group" "http_inbound" {
  name = "${var.employee_number}_sg"
  location = var.main_locaiton
  resource_group_name = azurerm_resource_group.main.name

  # Allow HTTP inbound traffic
  security_rule  {
    name = "HTTP_inbound_allow"
    protocol = "Tcp"
    source_port_range = "*"
    # destination_port_range = 22
    destination_port_range = 80
    source_address_prefix = var.client_ip
    # httpプロバイダー使用時はlocal変数を使用する
    # source_address_prefix = local.client_ip
    destination_address_prefix = "*"
    access = "Allow"
    priority = 100
    direction = "Inbound"
  }

  tags = {
    Name = var.employee_number
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id = azurerm_subnet.public_main.id
  network_security_group_id = azurerm_network_security_group.http_inbound.id
}