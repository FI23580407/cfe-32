#
# Fail-Safe Kubernetes log forwarder
# Copyright (C) 2023 Fail-Safe IT Solutions Oy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://github.com/FI23580407/FI23580407/blob/main/LICENSE>.
#
#
# Additional permission under GNU Affero General Public License version 3
# section 7
#
# If you modify this Program, or any covered work, by linking or combining it with
# other code, such other code is not for that reason alone subject to any of the
# requirements of the GNU Affero GPL version 3 as long as this Program is the same
# Program as licensed from Fail-Safe IT Solutions Oy without any additional
# modifications.
#
# Supplemented terms under GNU Affero General Public License version 3
# section 7
#
# Origin of the software must be attributed to Fail-Safe IT Solutions Oy.
# Any modified versions must be marked as "Modified version of" The Program.
#
# Names of the licensors and authors may not be used for publicity purposes.
#
# No rights are granted for use of trade names, trademarks, or service marks
# which are in The Program if any.
#
# Licensee must indemnify licensors and authors for any liability that these
# contractual assumptions impose on licensors and authors.

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
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]
