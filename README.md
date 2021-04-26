## mastodon helm chart

- https://joinmastodon.org/

Deploy a mastodon instance in OpenShift
```bash
helm upgrade --install my-mastodon .
```
### Generate Secrets for your mastodon

Prior to deploying, you should update and keep these secret.

The default values were created as follows:

```bash
-- generate a SECRET_KEY_BASE
podman run --rm -it tootsuite/mastodon bin/rake secret

-- generate otp
podman run --rm -it tootsuite/mastodon bin/rake secret

-- generate vapid
podman run --rm -it -e SECRET_KEY_BASE=b4b3f46e7ea91922b05c2352b6b17e32f87611b85c1ba65d1219d44a1bbb172dbd416c35bfd32a83ae19f11d2f2c38689af7e2493d018aa939459ccd3c449d93 -e OTP_SECRET=c1bbee5bdff1c3dbbf96d68d71c0b95f4ed76947cf1d4caf42d7053c3c062c77686d17c2a7119674c3f15a15586bd72dcb9fd3941bd4bf44f74acdbb381ed320 tootsuite/mastodon bundle exec rake mastodon:webpush:generate_vapid_key
```

### sign up users

If you have not set the SMTP vars, you may still accept users e.g.
```bash
oc rsh $(oc get pods -l app.kubernetes.io/name=mastodon-streaming-mastodon -o name)

RAILS_ENV=production bin/tootctl accounts modify eformat --confirm
RAILS_ENV=production bin/tootctl accounts modify eformat --role admin
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
