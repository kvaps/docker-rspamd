Rspamd in a Docker container
============================

Quick start
-----------

**run command**

```bash
docker run \
    --name rspamd \
    -h rspamd \
    -v /opt/rspamd:/data:rw \
    -p 11333:11333 \
    -p 11334:11334 \
    -d \
    kvaps/rspamd
```

Docker-compose
--------------

**docker-compose.yml**

```yaml
rspamd:
  restart: always
  image: kvaps/rspamd
  hostname: rspamd
  ports:
    - 11334:11334
  volumes:
    - /etc/localtime:/etc/localtime:ro
    - ./rspamd:/data
```
