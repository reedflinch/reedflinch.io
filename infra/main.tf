resource "aws_s3_bucket" "web" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  versioning {
    enabled = false
  }

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": "${aws_cloudfront_origin_access_identity.s3.s3_canonical_user_id}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
POLICY

  tags {
    type    = "website"
    service = "${var.domain}"
    domain  = "${var.domain}"
  }
}

resource "aws_cloudfront_origin_access_identity" "s3" {
  comment = "${var.domain}"
}

resource "aws_cloudfront_distribution" "web_s3" {
  origin {
    domain_name = "${aws_s3_bucket.web.bucket_domain_name}"
    origin_id   = "s3-${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.s3.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  default_root_object = "index.html"
  aliases             = ["*.${var.domain}", "${var.domain}"]
  http_version        = "http2"
  is_ipv6_enabled     = true

  default_cache_behavior {
    target_origin_id = "s3-${var.bucket_name}"
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    max_ttl                = 31536000
    default_ttl            = 86400
    compress               = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.web.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  tags {
    type    = "website"
    service = "${var.domain}"
    domain  = "${var.domain}"
  }
}

resource "aws_route53_zone" "main" {
  name = "reedflinch.io"
}
