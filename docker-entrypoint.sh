#!/bin/bash
set -e
if [ ! -f /config/config.json ]; then
    echo "Missing configuration files at /config";
    exit 1;
fi;

jq --arg dirs "/opt/Fail-Safe/kubernetes-forwarder/" '.dirs.var=($dirs + "var") | .dirs.etc=($dirs + "etc")' /config/config.json > /cfe-32/config/config.json;
cf-agent -Kf /cfe-32/kubernetes_forwarder.cf -b kubernetes_forwarder:kubernetes_forwarder;

/usr/sbin/rsyslogd -f /opt/Fail-Safe/kubernetes-forwarder/etc/rsyslog.conf -N9
exec /usr/sbin/rsyslogd -f /opt/Fail-Safe/kubernetes-forwarder/etc/rsyslog.conf -iNONE -n
