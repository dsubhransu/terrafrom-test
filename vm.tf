resource "azurerm_network_interface" "terraform-test1" {
  name                = "terraform-test-nic"
  location            = azurerm_resource_group.terraform-test.location
  resource_group_name = azurerm_resource_group.terraform-test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform-test.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "terraform-test" {
  name                = "terraform-test-machine01"
  resource_group_name = azurerm_resource_group.terraform-test.name
  location            = azurerm_resource_group.terraform-test.location
  size                = "Standard_D2_v2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.terraform-test.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04"
    version   = "latest"
  }
}
