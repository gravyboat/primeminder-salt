{% from "primeminder/map.jinja" import primeminder with context %}

{% set primeminder_proj = salt['pillar.get']('primeminder:proj') %}
{% set primeminder_user = salt['pillar.get']('primeminder:user') %}

include:
  - git
  - nginx

{{ primeminder_user }}:
  user.present:
    - name: {{ primeminder_user }}
    - shell: /bin/bash
    - home: /home/{{ primeminder_user }}
    - uid: 2150
    - gid: 2150
    - groups:
      - {{ primeminder.group }}
    - require:
      - group: {{ primeminder_user }}
  group.present:
    - gid: 2150

primeminder_git:
  git.latest:
    - name: git@gitlab.com:gravyboat/primeminder.git
    - target: /home/{{ primeminder_proj }}
    - user: {{ primeminder_user }}
    - identity: /home/primeminder/.ssh/primeminder_rsa
    - force_reset: True
    - force_clone: True
    - force_checkout: True
    - require:
      - pkg: install_git
    - watch_in:
      - service: nginx_service

primeminder_nginx_conf:
  file.managed:
    - name: /etc/nginx/conf.d/primeminder.conf
    - source: salt://primeminder/files/primeminder.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - git: primeminder_git
      - pkg: install_nginx
    - watch_in:
      - service: nginx_service

site_favicon:
  file.managed:
    - name: /home/{{ salt['pillar.get']('primeminder:proj') }}/favicon.ico
    - source: salt://primeminder/files/favicon.ico
    - template: jinja
    - user: {{ primeminder_user }}
    - group: {{ primeminder_user }}
    - mode: 644
    - require:
      - git: primeminder_git
      - pkg: install_nginx
    - watch_in:
      - service: nginx_service

remove_default_sites_enabled:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - watch_in:
      - service: nginx_service
