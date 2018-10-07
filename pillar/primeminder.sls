# primeminder environment settings

{% set primeminder_user = 'primeminder' %}
{% set primeminder_proj = '{0}/site'.format(primeminder_user) %}
{% set primeminder_url = 'primeminder.com' %}

primeminder:
  user: {{ primeminder_user }}
  proj: {{ primeminder_proj }}
  url: {{ primeminder_url }}
