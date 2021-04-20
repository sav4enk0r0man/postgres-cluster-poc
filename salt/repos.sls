RPM-GPG-KEY-PGDG:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - source: https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG

pgdg-common:
  pkgrepo.managed:
    - humanname: PostgreSQL common RPMs for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg13:
  pkgrepo.managed:
    - humanname: PostgreSQL 13 for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg12:
  pkgrepo.managed:
    - humanname: PostgreSQL 12 for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg11:
  pkgrepo.managed:
    - humanname: PostgreSQL 11 for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg10:
  pkgrepo.managed:
    - humanname: PostgreSQL 10 for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg96:
  pkgrepo.managed:
    - humanname: PostgreSQL 9.6 for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg95:
  pkgrepo.managed:
    - humanname: PostgreSQL 9.5 for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: True

pgdg-common-testing:
  pkgrepo.managed:
    - humanname: PostgreSQL common testing RPMs for RHEL/CentOS $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/testing/common/redhat/rhel-$releasever-$basearch
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - gpgcheck: 1
    - enabled: False
