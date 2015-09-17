Rspamd in a Docker container
============================

Run
---

```bash
docker run \
    --name rspamd \
    -h rspamd \
    -v /opt/rspamd:/data:rw \
    --env TZ=Europe/Moscow \
    -p 11333:11333 \
    -p 11334:11334 \
    -d \
    kvaps/rspamd
```

Systemd unit
------------

Example of systemd unit: `/etc/systemd/system/rspamd.service`

```bash
[Unit]
Description=rSpamd
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --name rspamd -h rspamd -v /opt/rspamd:/data --env TZ=Europe/Moscow -p 11334:11334 kvaps/rspamd
ExecStop=/usr/bin/docker stop -t 5 rspamd ; /usr/bin/docker rm -f rspamd

[Install]
WantedBy=multi-user.target
```
