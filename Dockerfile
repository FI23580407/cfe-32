FROM rockylinux:8
VOLUME /config
VOLUME /opt/Fail-Safe/kubernetes-forwarder/var
ADD https://cfengine-package-repos.s3.amazonaws.com/community_binaries/cfengine-community-3.9.1-1.x86_64.rpm /cfengine-community.rpm
COPY docker-entrypoint.sh /
RUN dnf -y install jq rsyslog rsyslog-relp rsyslog-mmkubernetes rsyslog-mmjsonparse nss_nis /cfengine-community.rpm \
  && rm -f /cfengine-community.rpm \
  && dnf clean all \
  && chmod +x /docker-entrypoint.sh
COPY src/main/cfengine/ /cfe-32/
ARG REVISION
LABEL REVISION=${REVISION}
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]
