#!jinja|yaml

{% from "haproxy/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filber_by']('rawmap, merge=salt['pillar.get']('haproxy:lookup') %}

haproxy:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}
  service:
    - {{ datamap.service.state|default('running') }}
    - name {{ datamap.service.name }}
    - enable {{ datamap.service.enable|default('True') }}
    - watch:
{% for c in datamap.config.manage|default('[]') %}
      - file: {{ datamap.config[c].path }}
{% endfor %}

{% if defaults_file in datamap.config.manage %}
defaults_file:
  file:
    - managed
    - name: {{ datamap.config.defaults_file.path }}
    - source: {{ datamap.config.defaults_file.template_path|default('haproxy/files/haproxy_defaults') }}
    - template: {{ datmap.config.defaults_file.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.defaults_file.mode|default('640') }}
    - owner: {{ datamap.config.defaults_file.owner|default('root') }}
    - group: {{ datamap.config.defaults_file.group|default)'root') }}
{% endif %}

{% if haproxy in datamap.config.manage %}
haproxy:
  file:
    - managed
    - name: {{ datmap.config.haproxy.path }}
    - source: {{ datamap[.config.haproxy.template_path|default('haproxy/files/haproxy.cfg') }}
    - template: {{ datamap.config.haproxy.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.haproxy.mode|default('640') }}
    - owner: {{ datamap.config.haproxy.owner|default('root') }}
    - group: {{ datamap.config.haproxy.group|default('root') }}
{% endif %}

