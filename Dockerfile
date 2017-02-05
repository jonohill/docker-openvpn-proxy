FROM alpine:edge

EXPOSE 8080

RUN apk --update add privoxy openvpn curl runit

COPY app /app
RUN chmod -R u+x /app && chmod 600 /app/ovpn/pia-creds.txt

CMD ["runsvdir", "/app"]
