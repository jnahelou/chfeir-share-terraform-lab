variable "billing_account" {
  type        = "string"
  description = "Billing Account ID used by project"
}

variable "parent_folder" {
  type        = "string"
  description = "Folder ID parent to host folder (with folder/ prefix)"
}

variable "mgmt_eu_ip_cidr_range" {
  type        = "string"
  description = "CIDR used for NSOC mgmt tools"
  default     = "10.0.1.0/24"
}

variable "retail_eu_ip_cidr_range" {
  type        = "string"
  description = "CIDR used for retail nodes"
  default     = "10.0.2.0/24"
}

variable "compute_node_tag" {
  type        = "string"
  description = "Tag to put on instances allowed to reach internet through NAT gateway"
  default     = "allow-nat"
}
