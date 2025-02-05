resource "aws_s3_bucket" "challenge_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "SecureAssetsBucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
}


resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.challenge_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.challenge_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.challenge_bucket.id

  rule {
    id = "size-rule"

    filter {
      object_size_greater_than = 500
    }

    # ... other transition/expiration actions ...
    
     noncurrent_version_expiration {
      noncurrent_days = 30
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.challenge_bucket.id

  rule {
    apply_server_side_encryption_by_default {  
      sse_algorithm     = "aws:kms"
    }
  }
}



resource "aws_s3_bucket_public_access_block" "secure_bucket_block" {
  bucket = aws_s3_bucket.challenge_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logging.s3.amazonaws.com"
      },
      "Action": ["s3:PutObject", "s3:PutObjectAcl"],
      "Resource": "${aws_s3_bucket.log_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_policy" "challenge_bucket_policy" {
  bucket = aws_s3_bucket.challenge_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logging.s3.amazonaws.com"
      },
      "Action": ["s3:PutObject", "s3:PutObjectAcl"],
      "Resource": "${aws_s3_bucket.challenge_bucket.arn}/log/*"
    }
  ]
}
EOF
}