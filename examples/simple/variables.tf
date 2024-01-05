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

variable "region" {
  type        = string
  description = "(Optional). AWS region."
  default     = "us-west-1"
}