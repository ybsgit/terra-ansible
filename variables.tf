variable "vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
}
variable "public_cidr" {
  type = list(string)
  default = ["10.1.0.0/24","10.1.1.0/24"]
}

variable "private_cidr" {
  type = list(string)
  default = ["10.1.2.0/24","10.1.3.0/24"]
}
