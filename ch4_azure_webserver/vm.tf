resource "azurerm_linux_virtual_machine" "web_server" {
  name = "${var.employee_number}-web-server"
  resource_group_name = azurerm_resource_group.main.name
  location = var.main_locaiton
  size = "Standard_A1_v2"

  disable_password_authentication = false
  admin_username = var.admin_username
  admin_password = var.admin_password

  lifecycle {
    ignore_changes = [admin_password]
  }

  # ユーザーデータをBase64にエンコード
  # user_data属性はBase64の書式しか受け付けない仕様
  user_data = base64encode(file("userdata.sh"))

  network_interface_ids = [azurerm_network_interface.web_server.id]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

}

resource "azurerm_network_interface" "web_server" {
  name = "${var.employee_number}_web_server_nic"
  resource_group_name = azurerm_resource_group.main.name
  location = var.main_locaiton

  ip_configuration {
    name = "${var.employee_number}_web_server_ip"
    subnet_id = azurerm_subnet.public_main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.web_server_ip.id
  }
}

resource "azurerm_public_ip" "web_server_ip" {
  name = "${var.employee_number}_web_server_pip"
  resource_group_name = azurerm_resource_group.main.name
  location = var.main_locaiton
  allocation_method = "Static"

  tags = {
    Name = var.employee_number
  }
}