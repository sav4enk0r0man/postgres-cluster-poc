postgresql-{{ pillar['postgresql_version'] }}:
  service.running:
    - enable: True
