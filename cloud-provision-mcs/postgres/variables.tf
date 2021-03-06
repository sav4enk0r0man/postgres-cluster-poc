variable "hostname" {
  description = "Name of postgres host"
  default = "localhost"
}

variable "postgres_keypair" {
  description = "MCS ssh keypair name"
  default = ""
}

variable "ssh_dir" {
  description = "SSH keys dir"
  default = "~/.ssh"
}

variable "ssh_private_key" {
  description = "SSH private key file name"
  default = "id_rsa"
}

variable "ssh_user" {
  description = "SSH username"
  default = "centos"
}

variable "postgres_volume_type" {
  description = "Host volume type (ceph/ssd)"
  default = "ssd"
}

variable "postgres_volume_size" {
  description = "Default host volume size"
  default = 50
}

variable "fip_network" {
  description = "Floating ip pool name"
  default = "ext-net"
}

variable "postgres_flavor_id" {
  description = "Host flavor id"
  default = "908479b5-1138-46b6-b746-48bf6c24e548" # Standard-4-8-80
}

variable "postgres_image_id" {
  description = "Host image id"
  default = "b228329c-869b-4778-a2db-7bbe5412bd14" # CentOS-7.6-201903
}

variable "network_id" {
  description = "Private network for postgres hosts"
  default = ""
}

variable "subnet_id" {
  description = "Subnet of postgres hosts"
  default = ""
}

variable "internal_network_id" {
  description = "Internal network for postgres hosts"
  default = ""
}

variable "internal_subnet_id" {
  description = "Subnet of postgres hosts"
  default = ""
}

variable "postgres_ip_witelist" {
  description = "Whitelist network for remote access to service ports"
  default = "0.0.0.0/0"
}

variable "provision_commands" {
  description = "Commands run during provisioning"
  default = [
    "uptime" # dummy command
  ]
}

variable "postgres_enable" {
  description = "Enable create postgres host"
  default = 0
}
