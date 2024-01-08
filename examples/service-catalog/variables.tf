variable "region" {
  type        = string
  description = "(Optional). AWS region."
  default     = "us-east-1"
}

variable "portfolio_name" {
  type        = string
  description = "AWS Control Tower default porfolio name"
  default     = "AWS Control Tower Account Factory Portfolio"
}

variable "aft_execution_name" {
  type        = string
  description = "IAM role for AFT Execution"
  default     = "AWSAFTExecution"
}