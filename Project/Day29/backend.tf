terraform {
  backend "s3" {
    bucket = "bhavin-tfstate-s31"
    # bucket = "terraformdemo24"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform_state-lock-bhavin"

  }
}