postgres.packages:
  pkg.installed:
    - pkgs:
      - postgresql13
      - postgresql13-server

'/usr/pgsql-13/bin/postgresql-13-setup initdb':
  cmd.run:
    - unless: "stat /var/lib/pgsql/13/data/base/"
