terraform {
  required_version = ">= 0.14.2"
}

# This section is documented in docs/README.md section: 4. Configuration
module "aws" {
  source         = "./aws"
  config_git_url = "https://github.com/ComputeCanada/puppet-magic_castle.git"
  config_version = "11.0"

  cluster_name = "jmte"
  domain       = "jmte.sundellopensource.com"
  # image: you need to adjust the image to your AWS region and provide a recent
  #        image, and that information isn't easily accessible. To do that, I've
  #        used the referenced script to get a list of relevant images.
  #
  #        ref: https://gist.github.com/gene1wood/56e42097e0f0ac1aace14cbc41ee3e11#file-create_centos7_cloudformation_ami_mapping-py
  #
  image        = "ami-0bc06212a56393ee1" # CentOS Linux 7, 7.9.2009, us-west-2, x86_64

  instances = {
    mgmt  = { type = "t3.large",  count = 1, tags = ["mgmt", "puppet", "nfs"] },
    login = { type = "t3.medium", count = 1, tags = ["login", "public", "proxy"] },
    node  = { type = "t3.medium",  count = 1, tags = ["node"] }
  }

  volumes = {
    nfs = {
      home     = { size = 10, type = "gp2" }
      project  = { size = 50, type = "gp2" }
      scratch  = { size = 50, type = "gp2" }
    }
  }

  public_keys = [file("~/.ssh/id_rsa.pub")]

  nb_users     = 10
  # Shared password, randomly chosen if blank
  guest_passwd = ""

  # AWS specifics
  # region: chosen to be co-located to cmip6-psd dataset on S3
  #
  #         ref: https://registry.opendata.aws/cmip6/
  #
  region            = "us-west-2"
}

output "accounts" {
  value = module.aws.accounts
}

output "public_ip" {
  value = module.aws.public_ip
}

## Uncomment to register your domain name with CloudFlare
# module "dns" {
#   source           = "./dns/cloudflare"
#   email            = "you@example.com"
#   name             = module.aws.cluster_name
#   domain           = module.aws.domain
#   public_instances = module.aws.public_instances
#   ssh_private_key  = module.aws.ssh_private_key
#   sudoer_username  = module.aws.accounts.sudoer.username
# }

## Uncomment to register your domain name with Google Cloud
# module "dns" {
#   source           = "./dns/gcloud"
#   email            = "you@example.com"
#   project          = "your-project-id"
#   zone_name        = "you-zone-name"
#   name             = module.aws.cluster_name
#   domain           = module.aws.domain
#   public_instances = module.aws.public_instances
#   ssh_private_key  = module.aws.ssh_private_key
#   sudoer_username  = module.aws.accounts.sudoer.username
# }

# output "hostnames" {
# 	value = module.dns.hostnames
# }
