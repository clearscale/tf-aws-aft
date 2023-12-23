locals {
  # Master/Root/Control Tower account
  account_master = (length([
    for account in var.accounts : account 
    if contains(["root", "ct", "controltower", "master"], account.key)
  ]) > 0 
    ? [for account in var.accounts : account 
       if contains(["root", "ct", "controltower", "master"], account.key)][0]
    : null
  )

  # Log Archive account
  account_logs = (length([
    for account in var.accounts : account 
    if contains([
      "log", "logs", "logarchive", "log_archive", "log-archive"
    ], account.key)
  ]) > 0 
    ? [for account in var.accounts : account 
       if contains([
        "log", "logs", "logarchive", "log_archive", "log-archive"
      ], account.key)][0]
    : null
  )

  # Audit account
  account_audit = (length([
    for account in var.accounts : account 
    if contains(["audit"], account.key)
  ]) > 0 
    ? [for account in var.accounts : account 
       if contains(["audit"], account.key)][0]
    : null
  )

  # AFT Management account
  account_aft = (length([
    for account in var.accounts : account 
    if contains(["aft", "management"], account.key)
  ]) > 0 
    ? [for account in var.accounts : account 
       if contains(["aft", "management"], account.key)][0]
    : null
  )

  repos_all = join(" ", [
    var.repo_accounts,
    var.repo_customization_global,
    var.repo_customization_account,
    var.repo_customization_provisioning
  ])

  contains_github    = length(regexall(".*github.com.*",    local.repos_all)) > 0
  contains_bitbucket = length(regexall(".*bitbucket.org.*", local.repos_all)) > 0

  # Determine the VCS provider based on the URL contents
  vcs_provider = ((
    length(trimspace(var.vcs_github_enterprise_url)) > 0 &&
    var.vcs_github_enterprise_url != "null"
  ) ? "githubenterprise"
    : (local.contains_github
      ? "github"
      : (local.contains_bitbucket
        ? "bitbucket"
        : "codecommit"
      )
    )
  )

  # Strip domains and protocols from repo location strings
  repo_accounts = (var.vcs_provider == "codecommit" 
    ? replace(var.repo_accounts, "^(https?://git-codecommit.[^/]+.amazonaws.com/v1/repos/)", "")
    : replace(var.repo_accounts, "^(https?://[^/]+/)", "")
  )

  repo_customization_global = (var.vcs_provider == "codecommit" 
    ? replace(var.repo_customization_global, "^(https?://git-codecommit.[^/]+.amazonaws.com/v1/repos/)", "")
    : replace(var.repo_customization_global, "^(https?://[^/]+/)", "")
  )

  repo_customization_account = (var.vcs_provider == "codecommit" 
    ? replace(var.repo_customization_account, "^(https?://git-codecommit.[^/]+.amazonaws.com/v1/repos/)", "")
    : replace(var.repo_customization_account, "^(https?://[^/]+/)", "")
  )

  repo_customization_provisioning = (var.vcs_provider == "codecommit" 
    ? replace(var.repo_customization_provisioning, "^(https?://git-codecommit.[^/]+.amazonaws.com/v1/repos/)", "")
    : replace(var.repo_customization_provisioning, "^(https?://[^/]+/)", "")
  )
}

variable "prefix" {
  type        = string
  description = "(Optional). Prefix override for all generated naming conventions."
  default     = "cs"
}

variable "client" {
  type        = string
  description = "(Optional). Name of the client."
  default     = "ClearScale"
}

variable "project" {
  type        = string
  description = "(Optional). Name of the client project."
  default     = "pmod"
}

variable "accounts" {
  description = "(Optional). List of cloud provider account info and backend type."
  type = list(object({
    key      = optional(string, "current")
    provider = optional(string, "aws")
    id       = optional(string, "*") 
    name     = string
    region   = optional(string, "us-west-1")
    backend  = optional(string, "s3")
  }))
}

variable "env" {
  type        = string
  description = "(Optional). Name of the current environment."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "(Optional). AWS region."
  default     = "us-west-1"
}

variable "name" {
  type        = string
  description = "(Optional). The name of the S3 state."
  default     = "default"
}

#
# AFT Terraform Distribution Variables
#
variable "tf_version" {
  type        = string
  description = "(Optional). Terraform version being used for AFT"
  default     = "1.6.1"
  validation {
    condition     = can(regex("\\bv?\\d+(\\.\\d+)+[\\-\\w]*\\b", var.tf_version))
    error_message = "Invalid value for var: tf_version."
  }
}

variable "tf_distribution" {
  type        = string
  description = "(Optional). Terraform distribution being used for AFT - valid values are oss, tfc, or tfe"
  default     = "oss"
  validation {
    condition     = contains(["oss", "tfc", "tfe"], var.tf_distribution)
    error_message = "Valid values for var: tf_distribution are (oss, tfc, tfe)."
  }
}

variable "tf_region_backup" {
  type        = string
  description = "(Optional). AFT creates a backend for state tracking for its own state as well as OSS cases. The backend's primary region is the same as the AFT region, but this defines the secondary region to replicate to."
  default     = "us-west-2"
  validation {
    condition     = var.tf_region_backup == "" || can(regex("(us(-gov)?|ap|ca|cn|eu|sa|me|af)-(central|(north|south)?(east|west)?)-\\d", var.tf_region_backup))
    error_message = "Variable var: tf_region_backup is not valid."
  }
}

variable "tf_token" {
  type        = string
  description = "(Optional). Terraform token for Cloud or Enterprise"
  default     = "null" # Non-sensitive default value #tfsec:ignore:general-secrets-no-plaintext-exposure
  sensitive   = true
  validation {
    condition     = length(var.tf_token) > 0
    error_message = "Variable var: tf_token cannot be empty."
  }
}

variable "tf_org_name" {
  type        = string
  description = "(Optional). Organization name for Terraform Cloud or Enterprise"
  default     = "null"
  validation {
    condition     = length(var.tf_org_name) > 0
    error_message = "Variable var: tf_org_name cannot be empty."
  }
}

variable "tf_api_endpoint" {
  type        = string
  description = "(Optional). API Endpoint for Terraform. Must be in the format of https://xxx.xxx."
  default     = "https://app.terraform.io/api/v2/"
  validation {
    condition     = length(var.tf_api_endpoint) > 0
    error_message = "Variable var: tf_api_endpoint cannot be empty."
  }
}

#
# AFT customer repositories
#
variable "repo_aft_framework" {
  type        = string
  description = "Git repo URL where the AFT framework should be sourced from"
  default     = "https://github.com/aws-ia/terraform-aws-control_tower_account_factory.git"
  validation {
    condition     = length(var.repo_aft_framework) > 0
    error_message = "Variable var: repo_aft_framework cannot be empty."
  }
}

variable "repo_branch_aft_framework" {
  type        = string
  description = "Git branch from which the AFT framework should be sourced from"
  default     = null
}

variable "vcs_provider" {
  type        = string
  description = "(Optional). Customer VCS provider override - valid inputs are codecommit, bitbucket, github, or githubenterprise"
  default     = "github"
  validation {
    condition     = contains(["codecommit", "bitbucket", "github", "githubenterprise"], var.vcs_provider)
    error_message = "Valid values for var: vcs_provider are (codecommit, bitbucket, github, githubenterprise)."
  }
}

variable "vcs_github_enterprise_url" {
  type        = string
  description = "(Optional). GitHub enterprise URL, if GitHub Enterprise is being used"
  default     = "null"
}

variable "repo_accounts" {
  type        = string
  description = "(Optional). Repository name for the account request files. For non-CodeCommit repos, name should be in the format of Org/Repo"
  default     = "https://github.com/clearscale/tf-aws-aft-accounts"
  validation {
    condition     = length(var.repo_accounts) > 0
    error_message = "Variable var: repo_accounts cannot be empty."
  }
}

variable "repo_branch_accounts" {
  type        = string
  description = "(Optional). Branch to source account request repo from"
  default     = "main"
  validation {
    condition     = length(var.repo_branch_accounts) > 0
    error_message = "Variable var: repo_branch_accounts cannot be empty."
  }
}

variable "repo_customization_global" {
  type        = string
  description = "(Optional). Repository name for the global customization files. For non-CodeCommit repos, name should be in the format of Org/Repo"
  default     = "https://github.com/clearscale/tf-aws-aft-customization-global"
  validation {
    condition     = length(var.repo_customization_global) > 0
    error_message = "Variable var: repo_customization_global cannot be empty."
  }
}

variable "repo_branch_customization_global" {
  type        = string
  description = "(Optional). Branch to source global customizations repo from"
  default     = "main"
  validation {
    condition     = length(var.repo_branch_customization_global) > 0
    error_message = "Variable var: repo_branch_customization_global cannot be empty."
  }
}

variable "repo_customization_account" {
  type        = string
  description = "(Optional). Repository name for the account customizations files. For non-CodeCommit repos, name should be in the format of Org/Repo"
  default     = "https://github.com/clearscale/tf-aws-aft-customization-account"
  validation {
    condition     = length(var.repo_customization_account) > 0
    error_message = "Variable var: repo_customization_account cannot be empty."
  }
}

variable "repo_branch_customization_account" {
  type        = string
  description = "(Optional). Branch to source account customizations repo from"
  default     = "main"
  validation {
    condition     = length(var.repo_branch_customization_account) > 0
    error_message = "Variable var: repo_branch_customization_account cannot be empty."
  }
}

variable "repo_customization_provisioning" {
  type        = string
  description = "(Optional). Repository name for the account provisioning customizations files. For non-CodeCommit repos, name should be in the format of Org/Repo"
  default     = "https://github.com/clearscale/tf-aws-aft-customization-account-provisioning"
  validation {
    condition     = length(var.repo_customization_provisioning) > 0
    error_message = "Variable var: repo_customization_provisioning cannot be empty."
  }
}

variable "repo_branch_customization_provisioning" {
  type        = string
  description = "(Optional). Branch to source account provisioning customization files"
  default     = "main"
  validation {
    condition     = length(var.repo_branch_customization_provisioning) > 0
    error_message = "Variable var: repo_branch_customization_provisioning cannot be empty."
  }
}

#
# AFT Feature Flags
#
variable "feature_enterprise" {
  type        = bool
  description = "(Optional). Feature flag toggling Enterprise Support enrollment on/off"
  default     = false
  validation {
    condition     = contains([true, false], var.feature_enterprise)
    error_message = "Valid values for var: feature_enterprise are (true, false)."
  }
}

variable "feature_audit_cloudtrail" {
  type        = bool
  description = "(Optional). Feature flag toggling CloudTrail data events on/off"
  default     = false
  validation {
    condition     = contains([true, false], var.feature_audit_cloudtrail)
    error_message = "Valid values for var: feature_audit_cloudtrail are (true, false)."
  }
}

variable "feature_audit_metrics" {
  description = "(Optional). Flag toggling reporting of operational metrics"
  type        = bool
  default     = true
  validation {
    condition     = contains([true, false], var.feature_audit_metrics)
    error_message = "Valid values for var: feature_audit_metrics are (true, false)."
  }
}

variable "feature_vpc_delete_default" {
  type        = bool
  description = "(Optional). Feature flag toggling deletion of default VPCs on/off"
  default     = true
  validation {
    condition     = contains([true, false], var.feature_vpc_delete_default)
    error_message = "Valid values for var: feature_vpc_delete_default are (true, false)."
  }
}

variable "feature_vpc_endpoints" {
  type        = bool
  description = "Flag turning VPC endpoints on/off for AFT VPC"
  default     = true
  validation {
    condition     = contains([true, false], var.feature_vpc_endpoints)
    error_message = "Valid values for var: feature_vpc_endpoints are (true, false)."
  }
}

#
# Networking
#
variable "vpc_cidr" {
  type        = string
  description = "(Optional). CIDR Block to allocate to the AFT VPC"
  default     = "10.12.0.0/20"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_cidr))
    error_message = "Variable var: vpc_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "vpc_private_subnet_01_cidr" {
  type        = string
  description = "(Optional). CIDR Block to allocate to the Private Subnet 01"
  default     = "10.12.1.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_private_subnet_01_cidr))
    error_message = "Variable var: vpc_private_subnet_01_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "vpc_private_subnet_02_cidr" {
  type        = string
  description = "(Optional). CIDR Block to allocate to the Private Subnet 02"
  default     = "10.12.2.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_private_subnet_02_cidr))
    error_message = "Variable var: vpc_private_subnet_02_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "vpc_public_subnet_01_cidr" {
  type        = string
  description = "(Optional). CIDR Block to allocate to the Public Subnet 01"
  default     = "10.13.1.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_public_subnet_01_cidr))
    error_message = "Variable var: vpc_public_subnet_01_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}

variable "vpc_public_subnet_02_cidr" {
  type        = string
  description = "(Optional). CIDR Block to allocate to the Public Subnet 02"
  default     = "10.13.2.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_public_subnet_02_cidr))
    error_message = "Variable var: vpc_public_subnet_02_cidr value must be a valid network CIDR, x.x.x.x/y."
  }
}