variable "rgname" {
    type = string
    description = "this is the name of resourse group"
  
}

variable "rglocation" {
    type = string
    description = "this is the location of resourse group"
    default = "Central India"
  
}

variable "network_name" {
    type = string
    description = "this is the virtual network "
  
}

variable "vnet_cidr_prefix" {
    type = string
    description = "this is the virtual network prefix value"
    
}

variable "network_subnet_name" {
    type = string
    description = "this is virtual network subnet name"
    default = "subnet1"
  
}
variable "subnet1_cidr_prefix" {
    type = string
    description = "this this subnet1 cidr prefix"

  
}

variable "subnet2_cidr_prefix" {
    type = string
    description = "this is subnet2 cidr prefix"
}

variable "nsg_rule1" {
    type = string
    description = "this is nsg rule1"
  
}

variable "vmname" {
    type = string
    description = "this is virtual machine name"
  
}

variable "vmsize" {
    type = string
    description = "this the size of vm"
    
  
}

variable "admin_username" {
    type = string
    description = "this is the local admin name of the vm"
    default = "terraformadmin"
  
}
variable "admin_password" {
    type = string

    description = "this is the password of the admin"
    default = "Terraformpassword@123"
  
}
