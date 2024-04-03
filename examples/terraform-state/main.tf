module "terraform_state_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "1.3.0"

  # AWS profile name as set in the shared credentials file
  # profile = "AWSAdministratorAccess-200928140680"
  # also set region in profile

  namespace   = "clearscale"
  stage       = "terraform"
  name        = "backend"
  environment = var.region
  attributes  = ["state"]

  label_order = ["namespace", "stage", "name", "environment", "attributes"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  terraform_version                  = "1.5.7"
  force_destroy                      = false

  dynamodb_enabled = false
  # use to destroy
  # terraform_backend_config_file_path = ""
  # force_destroy                      = true

  # Whether to create the S3 bucket
  # bucket_enabled = false
  # s3_bucket_name = "tf-backend-XXX"
}
