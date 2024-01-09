module "aft" {
  source  = "github.com/clearscale/tf-aws-aft"
  # source = "../../" # local testing

  accounts = var.accounts

  feature_enterprise         = false
  feature_audit_cloudtrail   = false
  feature_audit_metrics      = true
  feature_vpc_delete_default = true
  feature_vpc_endpoints      = true

  tf_version       = "1.5.7"
  tf_distribution  = "oss"
  tf_region_backup = "us-east-2"

  vpc_cidr                   = "192.168.0.0/22"
  vpc_private_subnet_01_cidr = "192.168.0.0/24"
  vpc_private_subnet_02_cidr = "192.168.1.0/24"
  vpc_public_subnet_01_cidr  = "192.168.2.0/25"
  vpc_public_subnet_02_cidr  = "192.168.2.128/25"

  vcs_provider                           = "github"
  repo_accounts                          = "clearscale/tf-aws-aft-accounts"
  repo_branch_accounts                   = "main"
  repo_customization_account             = "clearscale/tf-aws-aft-customization-account"
  repo_branch_customization_account      = "main"
  repo_customization_global              = "clearscale/tf-aws-aft-customization-global"
  repo_branch_customization_global       = "main"
  repo_customization_provisioning        = "clearscale/tf-aws-aft-customization-account-provisioning"
  repo_branch_customization_provisioning = "main"
}
