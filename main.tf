module "aft" {
  source  = "github.com/aws-ia/terraform-aws-control_tower_account_factory.git"

  ct_management_account_id                = local.account_master.id
  ct_home_region                          = local.account_master.region
  log_archive_account_id                  = local.account_logs.id
  audit_account_id                        = local.account_audit.id
  aft_management_account_id               = local.account_aft.id

  cloudwatch_log_group_retention          = 0
  concurrent_account_factory_actions      = 5
  maximum_concurrent_customizations       = 5
  global_codebuild_timeout                = 60

  aft_feature_enterprise_support          = var.feature_enterprise
  aft_feature_cloudtrail_data_events      = var.feature_audit_cloudtrail
  aft_metrics_reporting                   = var.feature_audit_metrics
  aft_feature_delete_default_vpcs_enabled = var.feature_vpc_delete_default
  aft_vpc_endpoints                       = var.feature_vpc_endpoints

  terraform_version                       = var.tf_version
  terraform_distribution                  = var.tf_distribution
  tf_backend_secondary_region             = var.tf_region_backup
  terraform_token                         = var.tf_token
  terraform_org_name                      = var.tf_org_name
  terraform_api_endpoint                  = var.tf_api_endpoint

  aft_vpc_cidr                            = var.vpc_cidr
  aft_vpc_private_subnet_01_cidr          = var.vpc_private_subnet_01_cidr
  aft_vpc_private_subnet_02_cidr          = var.vpc_private_subnet_02_cidr
  aft_vpc_public_subnet_01_cidr           = var.vpc_public_subnet_01_cidr
  aft_vpc_public_subnet_02_cidr           = var.vpc_public_subnet_02_cidr

  # VCS provider which is automatically determined by repo urls.
  vcs_provider          = local.vcs_provider
  github_enterprise_url = var.vcs_github_enterprise_url

  # https://github.com/aws-ia/terraform-aws-control_tower_account_factory
  aft_framework_repo_url     = var.repo_aft_framework
  aft_framework_repo_git_ref = var.repo_branch_aft_framework

  # Account Request Repositories (account definitions)
  # https://docs.aws.amazon.com/controltower/latest/userguide/aft-provision-account.html
  # https://github.com/hashicorp/learn-terraform-aft-account-request
  account_request_repo_name   = local.repo_accounts
  account_request_repo_branch = var.repo_branch_accounts

  # Global Customizations (customizations for all accounts)
  # https://docs.aws.amazon.com/controltower/latest/userguide/aft-account-customization-options.html
  # https://github.com/hashicorp/learn-terraform-aft-account-customizations
  global_customizations_repo_name   = local.repo_customization_global
  global_customizations_repo_branch = var.repo_branch_customization_global

  # Account customizations (customizations that target specific accounts)
  # https://github.com/hashicorp/learn-terraform-aft-account-customizations
  # https://docs.aws.amazon.com/controltower/latest/userguide/aft-account-customization-options.html
  account_customizations_repo_name   = local.repo_customization_account
  account_customizations_repo_branch = var.repo_branch_customization_account

  # Account Provisioning Customizations:
  # Allows for further integration by using an AWS Step Functions State Machine
  # https://docs.aws.amazon.com/controltower/latest/userguide/aft-provisioning-framework.html
  # https://github.com/hashicorp/learn-terraform-aft-account-provisioning-customizations
  account_provisioning_customizations_repo_name = (
    var.repo_customization_provisioning
  )
  account_provisioning_customizations_repo_branch = (
    var.repo_branch_customization_provisioning
  )

}