terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  
    subscription_id = "6dc04dce-61ca-4a0a-a008-d5a5e06b8b1a"
    client_id = "262befed-62f1-4ae3-9f89-3d15b75b4bc0"
    client_secret = "9G68Q~1IHAFNbcdozwrZdx7dqCtoauPJFft2Tdj7"
    tenant_id = "000cbff9-0cf0-4826-88f4-e8d0f8d13de3"
    features {
      
    }
 
}

resource "azurerm_resource_group" "test" {
  name = "${var.rgname}"
  location = "${var.rglocation}"
  
}

resource "azurerm_virtual_network" "network" {
  name = "${var.network_name}-test"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location = "${azurerm_resource_group.test.location}"
  address_space = ["${var.vnet_cidr_prefix}"]
}

resource "azurerm_subnet" "subnet1" {
  name = "${var.network_subnet_name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  address_prefixes = ["${var.subnet1_cidr_prefix}"]

}

resource "azurerm_network_security_group" "nsg1" {
  name = "${var.network_name}-nsg"
  resource_group_name = azurerm_resource_group.test.name
  location = azurerm_resource_group.test.location  
}

resource "azurerm_network_security_rule" "rdp" {
  name = "${var.nsg_rule1}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg1.name}"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "3389"
  source_address_prefix = "*"
  destination_address_prefix = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg_assosote" {
  subnet_id = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
  
}

resource "azurerm_network_interface" "nic1" {
  name = "${var.network_name}-nic"
  resource_group_name = azurerm_resource_group.test.name
  location = azurerm_resource_group.test.location
  
  ip_configuration {
    name = "internal1"
    subnet_id = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name = "${var.vmname}"
  resource_group_name = azurerm_resource_group.test.name
  location = azurerm_resource_group.test.location
  size = "${var.vmsize}"
  admin_username = "${var.admin_username}"
  admin_password = "${var.admin_password}"
  network_interface_ids = [azurerm_network_interface.nic1.id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2025-datacenter-azure-edition"
    version = "latest"
    }

//  source_image_id = "/subscriptions/6dc04dce-61ca-4a0a-a008-d5a5e06b8b1a/resourceGroups/Project/providers/Microsoft.Compute/galleries/railrootimage/images/railrootvm-windowsserver2025/versions/0.0.1"

  os_disk {
    name                 = "terrraformvm1-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  patch_mode = "AutomaticByPlatform"


//  security_type = "TrustedLaunch"

/*  security_profile {
    secure_boot_enabled = true
    vtpm_enabled        = true
  }*/

  tags = {
    environment = "Test"
  }
}
