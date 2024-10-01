provider "aws" {
  region = "us-east-1"
}

module "main_vpc_module" {
  source = "./modules/vpc"

  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "dev_website_module" {
  source = "./modules/static-website"

  bucket_name = "dev.terraform-multi-env.com"
  bucket_tag_name = "Frontend Dev"
  bucket_tag_env = "Development"
  main_website_path = "./modules/static-website/dev-website-files/index.html"
  error_website_path = "./modules/static-website/dev-website-files/error.html"
}

module "route53" {
  source = "./modules/route53"

  domain_name = "terraform-multi-env.com"
  subdomain_name = "dev.terraform-multi-env.com" 
  s3_web_domain = module.dev_website_module.website_domain
  s3_web_hosted_zone = module.dev_website_module.website_hosted_zone_id
}

output "dev_website_url" {
    value = module.dev_website_module.website_url
}