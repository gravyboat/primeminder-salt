base:
  'primeminder-prod-*':
    - nginx
    - fail2ban
    - ssh
    - letsencrypt.install
    - letsencrypt.config
    - letsencrypt.domains
    - primeminder.app
