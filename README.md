# OpenVPN Proxy

Uses Privoxy to proxy requests that hit *8080 to OpenVPN. All running on alpine Linux, so fast and light.

I've set it up to use the provider PIA's UK Servers, but you can add your own, then modify the respective line in `app/ovpn/run`.
PIA Publish thier configs for download here: https://www.privateinternetaccess.com/openvpn/openvpn.zip

## Setup

1. Add creds file to `app/ovpn/pia-creds.txt` - username on first line, password on 2nd.
2. Build - `docker build -t ovpn-proxy:latest .`
3. Run - `docker run -d --device=/dev/net/tun --cap-add=NET_ADMIN -v /etc/localtime:/etc/caltime:ro -p 8080:8080 ovpn-proxy`

Also included a `docker-compose.yml`
