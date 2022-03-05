# docker-openttd

Docker image for running a dedicated [OpenTTD](https://openttd.org/) server - (un)shamefully based on [bateau84/openttd](https://github.com/bateau84/openttd).

```sh
docker build \
    --build-arg OPENTTD_VERSION="12.1" \
    --build-arg OPENGFX_VERSION="7.1" \
    --tag openttd:latest .

docker run \
    --name openttd \
    -p 3979:3979/tcp \
    -p 3979:3979/udp \
    -e PUID=1024 \
    -e PGID=100 \
    -v /path/.openttd:/home/openttd/.openttd \
    -d openttd:latest
```
