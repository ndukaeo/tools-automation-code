terraform {
  backend "s3" {
    bucket = "learn-devops-terraform"
    key    = "tools/terraform.tfstate"
    region = "us-east-1"
  }
}




