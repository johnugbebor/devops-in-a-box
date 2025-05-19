variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string

}
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}
variable "private_subnet_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)

}

variable "public_subnet_cidr_blocks" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)

}
