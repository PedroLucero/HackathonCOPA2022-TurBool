variable "rg_name" {
  default = "RG-PROD-01"
}

variable "location" {
  default = "East US 2"
}

variable "vnet_name" {
  default = "VNET-PROD"
}

variable "subnet_name" {
  default = "Subnet-01"
}

variable "winVM_name" {
  default = "SRV-PROD-01-AZ"
}

variable "linVM_name" {
  default = "SRV-PROD-02-AZ"
}

variable "winVM_PIP_name" {
  default = "PIP-SRV-PROD-01-AZ"
}

variable "linVM_PIP_name" {
  default = "PIP-SRV-PROD-02-AZ"
}

variable "address_space" {
  default = ["10.150.0.0/16"]
}

variable "subnet_prefix" {
  default = ["10.150.0.0/24"]
}

variable "winVM_hostname" {
  default = "win-vm-host-hackapedrito"
}

variable "linVM_hostname" {
  default = "lin-vm-host-hackapedrito"
}

variable "netw_sg_name" {
  default = "netw-sg"
}

variable "netw_interf_name" {
  default = "netw-interface"
}

variable "bothVM_size" {
  default = "Standard_B2s"
}

variable "linimg_pub" {
  default = "Canonical"
}

variable "linimg_offer" {
  default = "UbuntuServer"
}

variable "linimg_sku" {
  default = "18.04-LTS"
}

variable "linimg_ver" {
  default = "latest"
}

variable "winimg_pub" {
  default = "MicrosoftWindowsServer"
}

variable "winimg_offer" {
  default = "WindowsServer"
}

variable "winimg_sku" {
  default = "2019-Datacenter"
}

variable "winimg_ver" {
  default = "latest"
}

####################################################

variable "admin_password" {
  description = "Administrator user name"
  #type        = string
  default = "admin!Pass1"
}

variable "admin_username" {
  description = "Administrator password"
  #type        = string
  default = "PedroL"
}
