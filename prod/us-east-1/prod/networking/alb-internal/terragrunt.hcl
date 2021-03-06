# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::ssh://git@github.com/alliedworld/infrastructure-modules.git//networking/alb?ref=v0.0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# When using the terragrunt xxx-all commands (e.g., apply-all, plan-all), deploy these dependencies before this module
dependencies {
  paths = [
    "../../vpc",
    "../../../../_global/route53-public",
    "../route53-private",
    "../../../mgmt/openvpn-server",
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  alb_name        = "prod-alb-internal"
  is_internal_alb = true

  # These are self-signed TLS certs we've generated that are used solely for communication within the AWS account between
  # services. You can find the certs in the tls folder.
  https_listener_ports_and_ssl_certs = [
    {
      port    = 443
      tls_arn = "arn:aws:iam::608056288583:server-certificate/services-prod.allied-world.aws"
    },
  ]
  https_listener_ports_and_ssl_certs_num = 1

  num_days_after_which_archive_log_data = 30
  num_days_after_which_delete_log_data  = 60
  access_logs_s3_bucket_name            = "allied-world-prod-alb-internal-access-logs"

  create_route53_entry = true
  domain_name          = "services-prod.allied-world.aws"

  # Only set this to true if, when running 'terragrunt destroy,' you want to delete the contents of the S3 bucket that
  # stores access logs. Note that you must set this to true and run 'terragrunt apply' FIRST, before running 'destroy'!
  force_destroy = false
}
