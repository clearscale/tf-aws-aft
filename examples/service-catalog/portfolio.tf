data "aws_caller_identity" "id" {}

locals {
  cmd = "aws servicecatalog list-portfolios --region ${var.region} | jq -r .PortfolioDetails"
}

data "aws_iam_role" "aft_role" {
  name = var.aft_execution_name
}

module "current_desired_capacity" {
  source = "digitickets/cli/aws"

  aws_cli_commands = ["servicecatalog", "list-portfolios"]
  aws_cli_query    = "PortfolioDetails[?DisplayName==`${var.portfolio_name}`]|[0].Id"
  region           = var.region
}

output "module" {
  description = "The ID of AWS Control Tower Account Factory Portfolio"
  value       = module.current_desired_capacity.result
}

resource "aws_servicecatalog_principal_portfolio_association" "aws_control_tower" {
  portfolio_id  = module.current_desired_capacity.result
  principal_arn = data.aws_iam_role.aft_role.arn
}