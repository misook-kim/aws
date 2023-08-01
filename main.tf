provider "aws" {
  region = var.common_region
}

locals {
  user_data = "${file("user_data.txt")}"

  subnet_ids_list = tolist(module.vpc.private_subnets)

  subnet_ids_random_index = random_id.index.dec % length(module.vpc.private_subnets)

  instance_subnet_id = local.subnet_ids_list[local.subnet_ids_random_index]

  tags = {
    CommonName  = var.common_name
    Environment = var.common_env
  }
}

resource "random_id" "index" {
  byte_length = 2
}

################################################################################
# EC2 Module
################################################################################

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  # version = "~> 3.0"

  name = var.instance_name

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = module.ec2_key_pair.key_pair_name
  monitoring             = false
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = local.instance_subnet_id

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  # get_password_data = false
  tags = local.tags
}

################################################################################
# EC2 Key pair Module
################################################################################

module "ec2_key_pair" {

  source = "terraform-aws-modules/key-pair/aws"

  key_name           = join("-", [var.instance_name,"key"])
  create_private_key = true
}

################################################################################
# Security Group Module
################################################################################
module "security_group" {

  source = "terraform-aws-modules/security-group/aws"

  # version = "~> 4.0"

  name        = join("-", [var.instance_name, "instance"])
  description = "Security group for instance"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [var.ingress_rule]
  #ingress_cidr_blocks = [for s in module.vpc.public_subnets_cidr_blocks : s.cidr_block]
  ingress_cidr_blocks =  module.vpc.public_subnets_cidr_blocks
  #egress_rules        = var.egress_rules

  tags = local.tags
}

################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.common_name
  cidr = var.vpc_cidr

  azs             = formatlist("${var.common_region}%s", var.azs)
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # enable_ipv6                     = true
  # assign_ipv6_address_on_creation = true
  # create_egress_only_igw          = true

  # public_subnet_ipv6_prefixes  = [0, 1, 2]
  # private_subnet_ipv6_prefixes = [3, 4, 5]

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames

  # enable_flow_log                      = true
  # create_flow_log_cloudwatch_iam_role  = true
  # create_flow_log_cloudwatch_log_group = true

  nat_gateway_tags = local.tags

  public_subnet_tags = merge(local.tags, { Role = "public" })

  private_subnet_tags = merge(local.tags, { Role = "private" })

  tags = local.tags
}
