terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

// Creating the S3 bucket
resource "aws_s3_bucket" "my_bucket" {
    bucket = var.bucket_name
    tags = {
        name = var.bucket_name,
        environment = var.environment
    }
}

// Creating an resource to make the bucket completly private
resource "aws_s3_bucket_public_access_block" "private_bucket_example" {
  bucket = var.bucket_name

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

// Mapping of local extensions
locals {
  mime_types = {
    "txt" = "text/txt"
    "html" = "text/html"
    "png" = "image/png"
  }
}

// Creating a resource to upload multiple files in a local directory
resource "aws_s3_object" "uploads_example" {
  // Defining a for each loop to read every file in current_path/uploads/*
  for_each = fileset("${path.module}/uploads/", "**/*")

  bucket = var.bucket_name
  key = each.value
  // Defining the path in the local computer where the files are stored
  source = "${path.module}/uploads/${each.value}"
  // filemd5 helps identifiyng current files and only uploading the modifies ones,
  // preventing from uploading duplicate ones
  etag = filemd5("${path.module}/uploads/${each.value}")

  // Automatic file extension assignation, to help AWS show the uploads file on the AWS console
  content_type = lookup(
    local.mime_types,
    regex("[^.]+$", each.value),
    "binary/octet-stream"
  )
}