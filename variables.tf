variable "vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
}

variable "access_ip" {
  type = string
  default = "0.0.0.0/0"
}
