resource "aws_s3_bucket" "bucket" {
    bucket = "${var.name}-tf-state"
    acl           = "private"
    # This is only here so we can destroy the bucket as part of automated tests.
    # You should not copy this for production usage.
    force_destroy = true

    versioning {
        enabled = true
    }

    tags {
        Name = "${var.name}-tf-state"
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "dynamodb" {
    name = "${var.name}-tf-state"
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    tags {
        Name = "${var.name}-tf-state"
    }
}
