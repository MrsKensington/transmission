FROM fedora
MAINTAINER Michael Ditum <docker@mikeditum.co.uk>

# Install transmission
RUN dnf install -y \
        transmission-daemon \
        php-cli \
        php-pecl-http
        
RUN dir="/var/lib/transmission-daemon" && \
    usermod -d $dir transmission && \
    [ -d $dir/downloads ] || mkdir -p $dir/downloads && \
    [ -d $dir/incomplete ] || mkdir -p $dir/incomplete && \
    [ -d $dir/info/blocklists ] || mkdir -p $dir/info/blocklists && \
    file="$dir/info/settings.json" && \
    touch $file && \
    sed -i '/"peer-port"/a\    "peer-socket-tos": "lowcost",' $file && \
    sed -i '/"port-forwarding-enabled"/a\    "queue-stalled-enabled": true,' $file && \
    sed -i '/"queue-stalled-enabled"/a\    "ratio-limit-enabled": true,' $file && \
    sed -i '/"rpc-whitelist"/a\    "speed-limit-up": 10,' $file && \
    sed -i '/"speed-limit-up"/a\    "speed-limit-up-enabled": true,' $file && \
    chown -Rh transmission. $dir

COPY transmission.sh /usr/bin/

VOLUME ["/var/lib/transmission-daemon"]

EXPOSE 9091 51413/tcp 51413/udp

ENTRYPOINT ["transmission.sh"]
