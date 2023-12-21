terraform {
  backend "s3" {
    bucket = "terraformaws97"
    key    = "eks-prod1.tfstate"
  }
}
