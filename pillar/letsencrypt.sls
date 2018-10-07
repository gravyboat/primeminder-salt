letsencrypt:
  config: |
    server = https://acme-v01.api.letsencrypt.org/directory
    email = primeminder@primeminder.com
    authenticator = webroot
    webroot-path = /home/{{ salt['pillar.get']('primeminder:proj') }}
    agree-tos = True
    renew-by-default = True
  domainsets:
    www:
      - {{ salt['pillar.get']('primeminder:url') }}
      - www.{{ salt['pillar.get']('primeminder:url') }}
