FROM alpine:latest

WORKDIR /app
RUN apk add --update --no-cache \
    bash \
    samba \
    samba-common-tools \
    samba-client \
    samba-server

COPY smb.conf /etc/samba/smb.conf

ARG USER="user"
ARG PASS="pass"
RUN adduser -D $USER && echo "$USER:$PASS" | chpasswd
RUN (echo $PASS; echo $PASS) | smbpasswd -s -a $USER

EXPOSE 137/udp 138/udp 139 445

#RUN smbd --foreground --no-process-group

CMD ["smbd","--foreground","--no-process-group"]
