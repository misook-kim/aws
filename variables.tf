variable "common_name" {
  description = "workspace name"
  default     = "sb-saas"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "common_env" {
  description = "workspace environment"
  default     = "prd" # production : prd, staging : stg, develop : dev, disaster recovery : dr
  type        = string
  nullable    = false
  sensitive   = false
}

variable "common_region" {
  description = "workspace region"
  default     = "ca-central-1"
  type        = string
  nullable    = false
  sensitive   = false
}


variable "vpc_cidr" {
  description = "vpc cidr"
  default     = "10.1.0.0/16"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "azs" {
  description = "azs"
  default     = ["a", "b"]
  type        = list(string)
  nullable    = false
  sensitive   = false

}


variable "public_subnet_cidrs" {
  description = "public_subnet_cidrs"
  default     = ["10.1.0.0/24", "10.1.1.0/24"]
  type        = list(string)
  nullable    = false
  sensitive   = false
}

variable "private_subnet_cidrs" {
  description = "private_subnet_cidrs"
  default     = ["10.1.100.0/24", "10.1.101.0/24"]
  type        = list(string)
  nullable    = false
  sensitive   = false
}

variable "enable_nat_gateway" {
  description = "enable_nat_gateway"
  default     = true
  type        = bool
}

variable "single_nat_gateway" {
  description = "single_nat_gateway"
  default     = true
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "enable_dns_hostnames"
  default     = true
  type        = bool
}

variable "ami_id" {
  description = "ami id"
  default     = "ami-0e33c2a00f703836a"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "instance_name" {
    description = "instance type"
    default = "sample"
    type = string
    nullable = false
    sensitive = false

}

variable "instance_type" {
    description = "instance type"
    default = "m5.large"
    type = string
    nullable = false
    sensitive = false

}

variable "instance_port" {
    description = "instance port"
    default = "8080"
    type = string
    nullable = false
    sensitive = false
}

variable "sg_role" {
    description = "sg role"
    default = "instance"
    type = string
    nullable = false
    sensitive = false
}

variable "ingress_rule" {
    description = "ingress role"
    default = "https-443-tcp"
    type = string
    nullable = false
    sensitive = false
}
