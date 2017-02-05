FROM alpine:edge

EXPOSE 8080

RUN apk --update add privoxy openvpn runit

COPY app /app

RUN find /app -name run | xargs chmod u+x

ENV OPENVPN_FILE_SUBPATH=pia/uk-london.ovpn \
    OPENVPN_USERNAME=null \
    OPENVPN_PASSWORD=null 

CMD ["runsvdir", "/app"]
