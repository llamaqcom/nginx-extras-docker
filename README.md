# Nginx Extras with Run-as User:Group Support

Unofficial dockerized build of nginx-extras - based on debian:stable-slim with run-as user:group support.

## Usage

Here is a basic snippet to help you get started creating a container.

```
docker run -dit --restart unless-stopped \
    --name nginx-extras \
    -p 80:80 -p 443:443 \
    -v </path/to/nginx/config/dir>:/opt/config \
    -e PUID=1000 \
    -e PGID=1000 \
    llamaq/nginx-extras
```

In case of `</path/to/nginx/config/dir>` is empty on host, it will be pre-populated with original nginx configuration.

## License

This container and its code is licensed under the MIT License and provided "AS IS", without warranty of any kind.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
