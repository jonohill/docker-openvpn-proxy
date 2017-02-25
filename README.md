# OpenVPN Proxy

A Privoxy container with OpenVPN - Built upon Alpine Linux so tiny, fast, light and awesome.

I've only included the UK PIA ovpn files, because that's all I need. But you can download the others from PIA and inlcude your own (here)[https://www.privateinternetaccess.com/openvpn/openvpn.zip] - Don't forget ot change the paths in the ovpn files!!

## Setup

```
docker run -d --device=/dev/net/tun --cap-add=NET_ADMIN \
    -e "OPENVPN_FILE_SUBPATH=pia/uk-london.ovpn" \
    -e "OPENVPN_USERNAME=null" \
    -e "OPENVPN_PASSWORD=null" \
    -e "LOCAL_NETWORK=192.168.1.0/24" \
    -v /etc/localtime:/etc/caltime:ro \
    -p 8080:8080 \
    andymeful/privoxy-openvpn

# Of course interpolating your own username and password above.. 
```

Also included a `docker-compose.yml`

### Environment Variables
`LOCAL_NETWORK` - The CIDR mask of the local IP addresses which will be acessing the proxy. This is so the response to a request makes it back to the client.  
`OPENVPN_FILE_SUBPATH` - Currently only 'pia/uk-london.ovpn' or 'pia/uk-southhampton.ovpn' are valid.  
`OPENVPN_USERNAME` / `OPENVPN_PASSWORD` - Credentials to connect to PIA