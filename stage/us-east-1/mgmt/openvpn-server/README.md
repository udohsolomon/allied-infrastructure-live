# OpenVPN Server

This Terraform Module deploys an [OpenVPN Server](https://openvpn.net/). This server acts as the entrypoint to your 
AWS account. You must connect to it (e.g. via SSH) before you can connect to any of your other servers, which are in 
private subnets. This way, you minimize the surface area you expose to attackers, and can focus all your efforts on 
locking down just a single server.





## Current configuration

The OpenVPN Server in these templates has been configured as follows:

* **ssh-grunt**: We have installed [ssh-grunt](https://github.com/gruntwork-io/module-security/tree/master/modules/ssh-grunt)
  on the server, so you can SSH to the server using your IAM username and a public key uploaded to your IAM
  account. Check out the [ssh-grunt docs](https://github.com/gruntwork-io/module-security/tree/master/modules/ssh-grunt)
  for more info.
* **SSH Key Pair**: The OpenVpn Server has also been configured to allow SSH access for the `ubuntu` user using the Key
  Pair `stage-openvpn-us-east-1-v1`. *This should only be used as an emergency backup* (e.g. if for some reason `ssh-grunt` is not
  working). Only trusted administrators should have access to this Key Pair. If you don't have access to it, email
  support@gruntwork.io and we will share it with you securely (e.g. using [Keybase](http://keybase.io/)).
* **AMI**: The AMI that is running for OpenVPN server is created from the [Packer](https://www.packer.io/) template
  [infrastructure-modules/mgmt/openvpn-server/packer/openvpn-server.json](https://github.com/alliedworld/infrastructure-modules/tree/master/mgmt/openvpn-server/packer/openvpn-server.json)
  in the [infrastructure-modules](https://github.com/alliedworld/infrastructure-modules) repo.
* **Terragrunt**: Instead of using Terraform directly, we are using a wrapper called
  [Terragrunt](https://github.com/gruntwork-io/terragrunt) that provides locking and enforces best practices. Required
  version `>=0.19.0`.
* **Terraform state**: We are using [Terraform Remote State](https://www.terraform.io/docs/state/remote/), which
  means the Terraform state files (the `.tfstate` files) are stored in an S3 bucket. If you use Terragrunt, it will
  automatically manage remote state for you based on the settings in the `terragrunt.hcl` file.





## Where is the Terraform code?

All the Terraform code for this module is defined in [infrastructure-modules/mgmt/openvpn-server](https://github.com/alliedworld/infrastructure-modules/tree/master/mgmt/openvpn-server).
When you run Terragrunt, it finds the URL of this module in the `terragrunt.hcl` file, downloads the Terraform code into
a temporary folder, copies all the files in the current working directory (including `terragrunt.hcl`) into the
temporary folder, and runs your Terraform command in that temporary folder.

See the [Terragrunt Remote Terraform configurations
documentation](https://github.com/gruntwork-io/terragrunt#remote-terraform-configurations) for more info.





## Applying changes

To deploy a new AMI for the OpenVPN Server, update the Packer template
[infrastructure-modules/mgmt/openvpn-server/packer/openvpn-server.json](https://github.com/alliedworld/infrastructure-modules/tree/master/mgmt/openvpn-server/packer/openvpn-server.json)
build a new AMI, and use Terraform to deploy it. 

To deploy changes with Terraform, do the following:

1. Make sure [Terraform](https://www.terraform.io/) and [Terragrunt](https://github.com/gruntwork-io/terragrunt) are
   installed.
1. Configure the secrets specified at the top of `terragrunt.hcl` as environment variables.
1. Run `terragrunt plan` to see the changes you're about to apply.
1. If the plan looks good, run `terragrunt apply`.





## More info

For more info, check out the Readme for this module in [infrastructure-modules/mgmt/openvpn-server](https://github.com/alliedworld/infrastructure-modules/tree/master/mgmt/openvpn-server).
