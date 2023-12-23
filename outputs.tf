output "account_master" {
  description = "Master account information."
  value       = local.account_master
}

output "account_logs" {
  description = "Log Archive account information."
  value       = local.account_logs
}

output "account_audit" {
  description = "Audit account information."
  value       = local.account_audit
}

output "account_aft" {
  description = "AFT Management account information."
  value       = local.account_aft
}

output "vcs_provider" {
  description = "The current VCS provider."
  value       = local.vcs_provider
}

output "repo_accounts" {
  description = "The AFT accounts definition repository."
  value       = var.repo_accounts
}

output "repo_customization_global" {
  description = "The AFT global customization repository."
  value       = local.repo_customization_global
}

output "repo_customization_account" {
  description = "The AFT account customization repository."
  value       = local.repo_customization_account
}

output "repo_customization_provisioning" {
  description = "The AFT account provisioning customization repo."
  value       = local.repo_customization_provisioning
}