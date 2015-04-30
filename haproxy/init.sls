#!jinja|yaml

{% from "haproxy/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('haproxy:lookup')) %}

haproxy:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}
  service:
    - {{ datamap.service.state|default('running') }}
    - name: {{ datamap.service.name }}
    - enable: {{ datamap.service.enable|default('True') }}
    - watch:
{% for c in datamap.config.manage|default([]) %}
      - file: {{ datamap.config[c].path }}
{% endfor %}

{% if 'defaults_file' in datamap.config.manage %}
defaults_file:
  file:
    - managed
    - name: {{ datamap.config.defaults_file.path }}
    - source: {{ datamap.config.defaults_file.template_path|default('salt://haproxy/files/haproxy_defaults') }}
    - template: {{ datamap.config.defaults_file.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.defaults_file.mode|default('640') }}
    - owner: {{ datamap.config.defaults_file.owner|default('root') }}
    - group: {{ datamap.config.defaults_file.group|default('root') }}
{% endif %}

{% if 'haproxy_cfg' in datamap.config.manage %}
haproxy_cfg:
  file:
    - managed
    - name: {{ datamap.config.haproxy_cfg.path }}
    - source: {{ datamap.config.haproxy_cfg.template_path|default('salt://haproxy/files/haproxy_cfg') }}
    - template: {{ datamap.config.haproxy_cfg.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.haproxy_cfg.mode|default('640') }}
    - owner: {{ datamap.config.haproxy_cfg.owner|default('root') }}
    - group: {{ datamap.config.haproxy_cfg.group|default('root') }}
{% endif %}

