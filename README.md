# docker-openttd

Docker image for running an [OpenTTD](https://openttd.org/) server, (un)shamefully based on [bateau84/openttd](https://github.com/bateau84/openttd).

```sh
docker build --tag openttd:latest .

docker run --name openttd \
    -p 3979:3979/tcp \
    -p 3979:3979/udp \
    -e PUID=1024 \
    -e PGID=100 \
    -v /path/.openttd:/home/openttd/.openttd \
    -d openttd:latest
```
