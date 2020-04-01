# OpenVPN Proxy

An HTTP proxy server which (selectively) tunnels traffic over an OpenVPN connection.

## Why?

If your company has a vast array of servers on different IP ranges (e.g. cloud servers/services) then it can be impractical to maintain a list of routes that OpenVPN should push to clients - it's much easier just to tunnel all the traffic.
But then things that need low latency suffer - video calls etc. Besides you might not want _all_ your traffic going through the company...

Another use case is for VPN services that let you appear in a different country. You may only want some websites' traffic to appear in this country.

## Usage

The easiest way to get started is with `docker-compose` - see `docker-compose.yml` for an example.
You can also just use `docker run` or any other way to run a docker container.
Note that special capabilities are required, specifically `NET_ADMIN` and access to `/dev/net/tun` device.

## Tags

~~It's best to use `latest` if you can. 
Or you can use a specific version tag - tags are based on the OpenVPN version.~~

TODO

### Mounts

Pass mounts for `docker-compose` in `volumes` or to `docker run` with `-v "<host_path>:<container_path>"`

| What | Host path | Container path |
|---|---|---|
| OpenVPN config file | Path to your config file | `/config/config.ovpn` (or the value of `OPENVPN_CONFIG_FILE`) |

### Environment Variables

Pass values for `docker-compose` in `environment` or to `docker run` with `-e "<VAR_NAME>:<value>"`

| Variable | Required? | Default | Example | Description |
|---|---|---|---|---|
| `LOCAL_NETWORK` | Yes | _none_ | `10.0.8.0/24` | Your local network's address. Required so return packets can reach you. |
| `OPENVPN_USERNAME` | No | _none_ | `bob@example.com` | VPN username |
| `OPENVPN_PASSWORD` | No | _none_ | `top-secret-123` | VPN password |
| `OPENVPN_AUTO_CONFIG` | No | `true` | `false` | By default, modify the OpenVPN config dynamically so that a reference to the username/password can be inserted. Disable if it causes trouble or you want control. |
| `OPENVPN_CONFIG_FILE` | No | `/config/config.ovpn` | `/my/path.ovpn` | Path to config file inside container |
| `OPENVPN_TUNNEL_HOSTS` | No | _none_ | `*.corp.com,*.corp.io` | Patterns of which hosts to tunnel, comma separated. Unset means everything is tunneled. See [Split Tunneling](#split-tunneling) |
| `OPENVPN_HOST` | No | `localhost` | `10.0.8.1` | Set this if this container runs on a different host to where you'll use it. |
| `OPENVPN_PROXY_PORT` | No | `8080` | `1234` | Change proxy listening port. This must match the host port so that the auto-config file is correct. |

### Ports

Pass ports for `docker-compose` in `ports` or to `docker run` with `-p <host_port>:<container_port>`.

| Container Port | Description |
|---|---|
| 80 | Serves the proxy auto-configuration script. See [Split Tunneling](#split-tunneling). |
| 8080 | Exposes HTTP proxy |

### Configure your apps

For apps that support it, use the auto-configuration script. Usually this is called "Automatic proxy configuration" - for example macOS calls it "Automatic Proxy Configuration", Firefox calls it "Automatic proxy configuration URL". Set the value to your container's proxy auto-configuration port, e.g. `http://localhost:8081` or whatever you mapped the container's port 80 to.

For apps that don't support auto-configuration scripts you can set the HTTP proxy directly (e.g. to `localhost:8080`) but be aware that you lose the split-tunneling so everything will go over the proxy.

#### SSH

You can tunnel SSH configurations, but this won't use your auto-configuration script. Instead install `corkscrew` and edit your `~/.ssh/config`. If you use `brew` you can `brew install corkscrew`.

Example SSH config:
```
Host *.corp.com
    ProxyCommand /usr/local/bin/corkscrew localhost 8080 %h %p
```

## Split Tunneling

An HTTP proxy server operates at the application layer and not on IP addresses so proxy configuration can be used to send traffic based on hostname patterns instead of IP address ranges.

The way this works is with a [Proxy auto-configuration script](https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file). The built-in script will split traffic based on the value of the `OPENVPN_TUNNEL_HOSTS` variable. The patterns used are [glob](https://en.wikipedia.org/wiki/Glob_(programming)) however you should stick with just `*` and `?` for maximum compatibility.

When your browser or other application wants to make a request to a given host, it will first check this script to decide whether to send the request through the proxy. Most apps/operating systems support this, see [Configure your apps](#configure-your-apps).

If you would like a completely custom configuration with more esoteric switching rules you can create your own auto-configuration script and mount this to `/app/nginx/proxy.pac`. Environment variables will be interpolated at runtime (e.g. anything like `${OPENVPN_HOST}`).

## Acknowledgements

This project started as a fork of https://github.com/andyn922/docker-openvpn-proxy. Thanks andyn922!

Here are the differences from the original:
- Generic, not focussed on PIA.
- Split tunneling (i.e. proxy auto-configuration script).
- Username/password auto-configuration.
- New configuration
- New docs
- ~~Automatic builds~~ TODO

And other minor changes.
