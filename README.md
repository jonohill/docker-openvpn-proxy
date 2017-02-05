# OpenVPN Proxy

A Privoxy container with OpenVPN - Built upon Alpine Linux so tiny, fast, light and awesome.

I've only included the UK PIA ovpn files, because that's all I need. But you can download the others from PIA and inlcude your own (here)[https://www.privateinternetaccess.com/openvpn/openvpn.zip] - Don't forget ot change the paths in the ovpn files!!

## Setup

```
docker run -d --device=/dev/net/tun --cap-add=NET_ADMIN \
    -e "OPENVPN_FILE_SUBPATH=pia/uk-london.ovpn" \
    -e "OPENVPN_USERNAME=<USERNAME>" \
    -e "OPENVPN_PASSWORD=<PASSWORD>" \
    -v /etc/localtime:/etc/caltime:ro \
    -p 8080:8080 \
    andymeful/privoxy-openvpn
```

Also included a `docker-compose.yml`
