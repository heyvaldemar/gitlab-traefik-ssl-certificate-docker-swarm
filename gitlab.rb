# GitLab URL (replace with yours)
external_url 'https://gitlab.heyvaldemar.net'
nginx['enable'] = true
nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['proxy_set_headers'] = {
  'X-Forwarded-Proto' => 'https',
  'X-Forwarded-Ssl' => 'on'
}
gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab-application-password')
gitlab_rails['initial_shared_runners_registration_token'] = File.read('/run/secrets/gitlab-runnner-token')
gitlab_rails['lfs_enabled'] = true
gitlab_rails['gitlab_shell_ssh_port'] = 2222
letsencrypt['enable'] = false

# GitLab Registry URL (replace with yours)
registry_external_url 'https://registry.heyvaldemar.net'
gitlab_rails['registry_enabled'] = true
registry['enable'] = true
registry['registry_http_addr'] = "0.0.0.0:5000"
registry_nginx['enable'] = false

# GitLab SMTP (replace with yours)
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp-relay.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "gitlab@heyvaldemar.net"
gitlab_rails['smtp_password'] = "YourPassword"
gitlab_rails['smtp_domain'] = "smtp-relay.gmail.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
gitlab_rails['gitlab_email_from'] = "gitlab@heyvaldemar.net"
gitlab_rails['gitlab_email_reply_to'] = "gitlab@heyvaldemar.net"

# GitLab Active Directory (replace with yours)
gitlab_rails['ldap_enabled'] = true
gitlab_rails['prevent_ldap_sign_in'] = false
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main: # 'main' is the GitLab 'provider ID' of this LDAP server
    label: 'LDAP'
    host: 'domain-controller.heyvaldemar.net'
    port: 389
    uid: 'sAMAccountName'
    bind_dn: 'gitlab-ldap@heyvaldemar.net'
    password: 'YourPassword'
    encryption: 'plain'
    verify_certificates: true
    smartcard_auth: false
    active_directory: true
    allow_username_or_email_login: false
    lowercase_usernames: false
    block_auto_created_users: false
    base: 'OU=Users,DC=heyvaldemar,DC=net'
    user_filter: ''
EOS
