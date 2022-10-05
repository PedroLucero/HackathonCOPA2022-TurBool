terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "COPA_RG" {
  name     = var.rg_name
  location = var.location

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = azurerm_resource_group.COPA_RG.name

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.COPA_RG.name
  address_prefixes     = var.subnet_prefix

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

# WINDOWS VM PUBLIC IP
resource "azurerm_public_ip" "winVM_PIP" {
  name                = var.winVM_PIP_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name
  allocation_method   = "Static"
  domain_name_label   = var.winVM_hostname

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

#LINUX VM PUBLIC IP
resource "azurerm_public_ip" "linVM_PIP" {
  name                = var.linVM_PIP_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name
  allocation_method   = "Static"
  domain_name_label   = var.linVM_hostname

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

# Create Network security group GOTTA SETUP
resource "azurerm_network_security_group" "netw_sg" {
  name                = var.netw_sg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

# Create Network interface for windows
resource "azurerm_network_interface" "win_netw_interf" {
  name                = "windows-network-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name

  ip_configuration {
    name                          = "netw-interface-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.winVM_PIP.id
  }

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

# Create Network interfacefor linux
resource "azurerm_network_interface" "lin_netw_interf" {
  name                = var.netw_interf_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name

  ip_configuration {
    name                          = "netw-interface-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linVM_PIP.id
  }

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }
}

#Linux VM
resource "azurerm_linux_virtual_machine" "lin_VM" {
  name                = var.linVM_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name
  size                = var.bothVM_size
  #custom_data         = filebase64("customdata_test.sh")

  network_interface_ids = ["${azurerm_network_interface.lin_netw_interf.id}"]

  computer_name                   = var.linVM_name
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = var.linimg_pub
    offer     = var.linimg_offer
    sku       = var.linimg_sku
    version   = var.linimg_ver
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 60
  }

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }

}

#Windows VM
resource "azurerm_windows_virtual_machine" "win_VM" {
  name                = var.winVM_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_RG.name
  size                = var.bothVM_size
  #custom_data         = filebase64("customdata_test.sh")

  network_interface_ids = ["${azurerm_network_interface.win_netw_interf.id}"]

  computer_name  = var.winVM_name
  admin_username = var.admin_username
  admin_password = var.admin_password

  source_image_reference {
    publisher = var.winimg_pub
    offer     = var.winimg_offer
    sku       = var.winimg_sku
    version   = var.winimg_ver
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 128
  }

  tags = {
    CREATEDBY = "TurBool"
    DPT       = "VENTAS"
    AMBIENTE  = "PRD"
  }

}
