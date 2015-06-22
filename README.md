Rspamd in a Docker container
============================

Run
---

```bash
docker run \
    --name rspamd \
    -h rspamd \
    -v /data/rspamd:/data:rw \
    -p 11333:11333 \
    -p 11334:11334 \
    -d \
    kvaps/rspamd
```
