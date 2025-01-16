terraform {
  required_version = "1.10.4"
  backend "s3" {
    bucket = "devopsportfolioeksbucket"
    key = "state/terraform.state"
    region = "us-east-1"
    dynamodb_table = "tfremotestate-ec2"
  }
}
