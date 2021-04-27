### Podman local

You can run a local development environment for playing around with
```bash
podman run --name=mastodon_db_1 -d --network host -e POSTGRES_PASSWORD=password -e POSTGRES_DB=mastodon -e POSTGRES_USER=mastodon --add-host db:127.0.0.1 --add-host mastodon_db_1:127.0.0.1 --add-host redis:127.0.0.1 --add-host mastodon_redis_1:127.0.0.1 --add-host web:127.0.0.1 --add-host mastodon_web_1:127.0.0.1 --add-host streaming:127.0.0.1 --add-host mastodon_streaming_1:127.0.0.1 --add-host sidekiq:127.0.0.1 --add-host mastodon_sidekiq_1:127.0.0.1 --hostname db postgres:9.6-alpine

podman run --name=mastodon_redis_1 -d --network host --add-host db:127.0.0.1 --add-host mastodon_db_1:127.0.0.1 --add-host redis:127.0.0.1 --add-host mastodon_redis_1:127.0.0.1 --add-host web:127.0.0.1 --add-host mastodon_web_1:127.0.0.1 --add-host streaming:127.0.0.1 --add-host mastodon_streaming_1:127.0.0.1 --add-host sidekiq:127.0.0.1 --add-host mastodon_sidekiq_1:127.0.0.1 --hostname redis redis:6.0-alpine

podman run --name=mastodon_web_1 --network host --env-file ~/git/mastodon/.env.production --add-host db:127.0.0.1 --add-host mastodon_db_1:127.0.0.1 --add-host redis:127.0.0.1 --add-host mastodon_redis_1:127.0.0.1 --add-host web:127.0.0.1 --add-host mastodon_web_1:127.0.0.1 --add-host streaming:127.0.0.1 --add-host mastodon_streaming_1:127.0.0.1 --add-host sidekiq:127.0.0.1 --add-host mastodon_sidekiq_1:127.0.0.1 -p 3000:3000 -e SKIP_POST_DEPLOYMENT_MIGRATIONS=true tootsuite/mastodon bash -c "rails db:migrate"

podman stop mastodon_web_1 && podman rm mastodon_web_1

podman run --name=mastodon_web_1 -d --network host --env-file ~/git/mastodon/.env.production --add-host db:127.0.0.1 --add-host mastodon_db_1:127.0.0.1 --add-host redis:127.0.0.1 --add-host mastodon_redis_1:127.0.0.1 --add-host web:127.0.0.1 --add-host mastodon_web_1:127.0.0.1 --add-host streaming:127.0.0.1 --add-host mastodon_streaming_1:127.0.0.1 --add-host sidekiq:127.0.0.1 --add-host mastodon_sidekiq_1:127.0.0.1 -p 3000:3000 tootsuite/mastodon bash -c "rm -f /mastodon/tmp/pids/server.pid; bundle exec rails s -p 3000"

podman run --name=mastodon_streaming_1 -d --network host --env-file ~/git/mastodon/.env.production --add-host db:127.0.0.1 --add-host mastodon_db_1:127.0.0.1 --add-host redis:127.0.0.1 --add-host mastodon_redis_1:127.0.0.1 --add-host web:127.0.0.1 --add-host mastodon_web_1:127.0.0.1 --add-host streaming:127.0.0.1 --add-host mastodon_streaming_1:127.0.0.1 --add-host sidekiq:127.0.0.1 --add-host mastodon_sidekiq_1:127.0.0.1 -p 4000:4000  tootsuite/mastodon node ./streaming

podman run --name=mastodon_sidekiq_1 -d --network host --env-file ~/git/mastodon/.env.production --add-host db:127.0.0.1 --add-host mastodon_db_1:127.0.0.1 --add-host redis:127.0.0.1 --add-host mastodon_redis_1:127.0.0.1 --add-host web:127.0.0.1 --add-host mastodon_web_1:127.0.0.1 --add-host streaming:127.0.0.1 --add-host mastodon_streaming_1:127.0.0.1 --add-host sidekiq:127.0.0.1 --add-host mastodon_sidekiq_1:127.0.0.1 tootsuite/mastodon bundle exec sidekiq

podman run --name=local-minio_minio_1 -d --network host -v ~/git/mastodon/minio-data:/data:z --add-host minio:127.0.0.1 --add-host local-minio_minio_1:127.0.0.1 --hostname minio quay.io/eformat/mlminio:latest server /data
```

To stop/reset
```bash
--
podman stop mastodon_web_1 && podman rm mastodon_web_1
podman stop mastodon_sidekiq_1 && podman rm mastodon_sidekiq_1
podman stop mastodon_streaming_1 && podman rm mastodon_streaming_1
podman stop mastodon_redis_1 && podman rm mastodon_redis_1
podman stop mastodon_db_1 && podman rm mastodon_db_1
podman stop local-minio_minio_1 && podman rm local-minio_minio_1
podman volume prune
```

And the env file (matches helm chart defaults)
```bash
# Federation
# ----------
# This identifies your server and cannot be changed safely later
# ----------
LOCAL_DOMAIN=localhost

# Redis
# -----
REDIS_HOST=localhost
REDIS_PORT=6379

# PostgreSQL
# ----------
DB_HOST=localhost
DB_USER=mastodon
DB_NAME=mastodon
DB_PASS=password
DB_PORT=5432

# ElasticSearch (optional)
# ------------------------
ES_ENABLED=false
ES_HOST=localhost
ES_PORT=9200

# Secrets
# -------
# Make sure to use `rake secret` to generate secrets
# -------
SECRET_KEY_BASE==b4b3f46e7ea91922b05c2352b6b17e32f87611b85c1ba65d1219d44a1bbb172dbd416c35bfd32a83ae19f11d2f2c38689af7e2493d018aa939459ccd3c449d93
OTP_SECRET=c1bbee5bdff1c3dbbf96d68d71c0b95f4ed76947cf1d4caf42d7053c3c062c77686d17c2a7119674c3f15a15586bd72dcb9fd3941bd4bf44f74acdbb381ed320

# Web Push
# --------
# Generate with `rake mastodon:webpush:generate_vapid_key`
# --------
VAPID_PRIVATE_KEY=Hyxd4kmRTD4D8dkDEh34_DanHjzd1ya6aHjNK4KsPww=
VAPID_PUBLIC_KEY=BDJOQqRj-sORfK_9gsDZrtQQjNV45UbQ5KYw0BcLXIwp1pimyXKSqH5yYAqDqbALJXp4QoJbE-QPrpq99z15k-I=

# Sending mail
# ------------
SMTP_SERVER=smtp.eu.mailgun.org
SMTP_PORT=2525
SMTP_LOGIN=
SMTP_PASSWORD=
SMTP_FROM_ADDRESS=

# File storage (optional)
# -----------------------
S3_ENABLED=true
S3_BUCKET=mastodon
AWS_ACCESS_KEY_ID=minioadmin
AWS_SECRET_ACCESS_KEY=minioadmin
#S3_REGION=
S3_PROTOCOL=https
S3_HOSTNAME=localhost
S3_ENDPOINT=http://localhost:9000/
```

And nginx running locally - `/etc/nginx/sites-enabled/mastodon`

```bash
map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

upstream backend {
    server 127.0.0.1:3000 fail_timeout=0;
}

upstream streaming {
    server 127.0.0.1:4000 fail_timeout=0;
}

upstream minio {
    server 127.0.0.1:9000 fail_timeout=0;
}

proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=CACHE:10m inactive=7d max_size=1g;

server {
  listen 80;
  listen [::]:80;
  server_name localhost;
  root /home/mastodon/live/public;
  location /.well-known/acme-challenge/ { allow all; }
  location / { return 301 https://$host$request_uri; }
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name localhost;

  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!MEDIUM:!LOW:!aNULL:!NULL:!SHA;
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;

  # Uncomment these lines once you acquire a certificate:
  # ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
  # ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
  ssl_certificate      /etc/nginx/ssl/localhost.crt;
  ssl_certificate_key  /etc/nginx/ssl/localhost.key;

  keepalive_timeout    70;
  sendfile             on;
  client_max_body_size 80m;

  root /home/mastodon/live/public;

  gzip on;
  gzip_disable "msie6";
  gzip_vary on;
  gzip_proxied any;
  gzip_comp_level 6;
  gzip_buffers 16 8k;
  gzip_http_version 1.1;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  add_header Strict-Transport-Security "max-age=31536000";

  location / {
    try_files $uri @proxy;
  }

  location ~ ^/(emoji|packs|system/accounts/avatars|system/media_attachments/files) {
    add_header Cache-Control "public, max-age=31536000, immutable";
    add_header Strict-Transport-Security "max-age=31536000";
    try_files $uri @proxy;
  }

  location /sw.js {
    add_header Cache-Control "public, max-age=0";
    add_header Strict-Transport-Security "max-age=31536000";
    try_files $uri @proxy;
  }

  location @proxy {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Proxy "";
    proxy_pass_header Server;

    proxy_pass http://backend;
    proxy_buffering on;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;

    proxy_cache CACHE;
    proxy_cache_valid 200 7d;
    proxy_cache_valid 410 24h;
    proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    add_header X-Cached $upstream_cache_status;
    add_header Strict-Transport-Security "max-age=31536000";

    tcp_nodelay on;
  }

  location /api/v1/streaming {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Proxy "";

    proxy_pass http://streaming;
    proxy_buffering off;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;

    tcp_nodelay on;
  }

  location /mastodon{
    # minio Object Storage
    #rewrite ^ /minio/mastodon/$1?$args permanent;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header Proxy "";

    proxy_pass http://minio;
    proxy_redirect off;
    proxy_http_version 1.1;

    proxy_cache_revalidate on;
    proxy_buffering on;
    proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    proxy_cache_background_update on;
    proxy_cache_lock on;
    proxy_cache_valid 1d;
    proxy_cache_valid 404 1h;

    tcp_nodelay on;
    expires 1y;

  }

  error_page 500 501 502 503 504 /500.html;
}
```
