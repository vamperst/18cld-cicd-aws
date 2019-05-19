terraform {
  backend "s3" {
    bucket = "18cld-teste-prod"
    key    = "test-devops"
    region = "us-east-1"
  }
}
