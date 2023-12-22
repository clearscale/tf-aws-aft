module "aft" {
  source                      = "github.com/aws-ia/terraform-aws-control_tower_account_factory"
  # version = "1.11.1"

  ct_management_account_id    = var.ct_management_account_id
  log_archive_account_id      = var.log_archive_account_id
  audit_account_id            = var.audit_account_id
  aft_management_account_id   = var.aft_management_account_id
  ct_home_region              = var.ct_home_region
  tf_backend_secondary_region = var.tf_backend_secondary_region

  vcs_provider                                  = "github"
  account_request_repo_name                     = "${var.github_username}/aws-lz-setup"
  account_request_repo_branch                   = "account_request"

  account_provisioning_customizations_repo_name = "${var.github_username}/aws-lz-setup"
  # account_provisioning_customizations_repo_branch

  global_customizations_repo_name    = "${var.github_username}/aws-lz-setup"
  global_customizations_repo_branch  = "global_customization"

  account_customizations_repo_name   = "${var.github_username}/aws-lz-setup"
  account_customizations_repo_branch = "account_customization"

  # aft_feature_cloudtrail_data_events
  # aft_feature_delete_default_vpcs_enabled
  # aft_feature_enterprise_support

  # cloudwatch_log_group_retention
}
