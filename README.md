## mastodon helm chart

- https://joinmastodon.org/

Deploy a mastodon instance in OpenShift
```bash
helm upgrade --install my-mastodon .
```
### Generate Secrets for your mastodon

The default values were created as follows, you should update and keep these secret:

```bash
-- generate a SECRET_KEY_BASE
podman run --rm -it tootsuite/mastodon bin/rake secret

-- generate otp
podman run --rm -it tootsuite/mastodon bin/rake secret

-- generate vapid
podman run --rm -it -e SECRET_KEY_BASE=b4b3f46e7ea91922b05c2352b6b17e32f87611b85c1ba65d1219d44a1bbb172dbd416c35bfd32a83ae19f11d2f2c38689af7e2493d018aa939459ccd3c449d93 -e OTP_SECRET=c1bbee5bdff1c3dbbf96d68d71c0b95f4ed76947cf1d4caf42d7053c3c062c77686d17c2a7119674c3f15a15586bd72dcb9fd3941bd4bf44f74acdbb381ed320 tootsuite/mastodon bundle exec rake mastodon:webpush:generate_vapid_key
```