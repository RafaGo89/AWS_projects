variable "aws_region" {
    type = string
    description = "Region where the S3 bucket will be deployed"
    default = "us-east-1"
}

variable "bucket_name" {
    type = string
    description = "Unique name for the S3 bucket"
    default = "bucket-example-randomname"
}

variable "environment" {
   type = string
   description = "Type of environment where this bucket will be deployed"
   default = "dev"
}