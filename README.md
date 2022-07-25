# Samba Docker

### Dockerfile
alpine -> install samba -> copy smb.conf -> start samba

### Set user and password in **Dockerfile**
```
# this section can be used multiple times for multiple users
ARG USER="user"
ARG PASS="pass"
RUN adduser -D $USER && echo "$USER:$PASS" | chpasswd
RUN (echo $PASS; echo $PASS) | smbpasswd -s -a $USER
```

### edit **smb.conf**
```
[global]
protocol = SMB3
   workgroup = WORKGROUP
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes

#======================= Share Definitions =======================
[Share] 
path = /home/user
writeable = yes 
; browseable = yes 
valid users = user
force user = user
force group = user
create mask = 0770 
directory mask = 0771 
force create mode = 0660 
force directory mode = 0770 
```

### create share solders
```
mkdir /path/to/share
```

### map volumes in **docker-compose.yml**
```
    volumes:
      - '/path/to/share:/home/user'
```


## docker
```
docker build --tag samba .

docker run --name=samba -v /path/to/share:/home/user -p 139:139/udp -p 445:445/tcp samba
```
## docker-compose.yml
```
docker-compose up -d
```