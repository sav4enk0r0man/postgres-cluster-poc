postgres.packages:
  pkg.installed:
    - pkgs:
      - postgresql{{ pillar['postgresql_version'] }}
      - postgresql{{ pillar['postgresql_version'] }}-server

'/usr/pgsql-13/bin/postgresql-13-setup initdb':
  cmd.run:
    - unless: "stat /var/lib/pgsql/{{ pillar['postgresql_version'] }}/data/base/"
