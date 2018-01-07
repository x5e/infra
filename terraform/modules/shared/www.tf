
resource "aws_s3_bucket" "www" {

  bucket = "${data.aws_caller_identity.whoami.account_id}-${var.env_name}-www"
  tags {
    Environment = "${var.env_name}"
    Service = "www"
  }
  website {
    index_document = "index.html"
    error_document = "error.html"

  }
  acl = "public-read"
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "arn:aws:s3:::${data.aws_caller_identity.whoami.account_id}-${var.env_name}-www/*"
        }
    ]
}
EOF
}

/*
resource "aws_ssm_parameter" "www" {

  name = "/${var.env_name}/www/BUCKET"
  type = "SecureString"
  value = "${aws_s3_bucket.www.bucket}"
  overwrite = "true"
}
*/