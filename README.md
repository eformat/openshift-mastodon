in
```

### minio s3 bucket - remove list

We want to make the s3 bucket non listable, but anonymous read-only access with the link, need to use aws cli:

```bash
export AWS_PROFILE=minio
aws --endpoint-url http://localhost:9000 s3api put-bucket-policy --bucket mastodon --policy file:///mastodon/policy.json

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Resource": [
        "arn:aws:s3:::mastodon/*"
      ],
      "Sid": ""
    }
  ]
}
```
