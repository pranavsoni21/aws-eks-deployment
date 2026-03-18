variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_counts" {
  type = number
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}