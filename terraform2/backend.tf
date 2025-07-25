terraform {
  backend "s3" {
    bucket = "kartstream-tf-state"
    key    = "terraform/infra.tfstate"
    region = "eu-north-1"
  }
}