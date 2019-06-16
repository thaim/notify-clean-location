terraform {
  backend "s3" {
    bucket = "tfstate-thaim-common"
    key    = "notify-clean-location/terraform.tfstate"
    region = "ap-northeast-1"
  }

  required_version = "= 0.12.2"
}
