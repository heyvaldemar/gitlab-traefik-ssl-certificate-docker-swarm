# GitLab with SSL Certificate in a Docker Swarm

Install Docker Swarm by following my [guide](https://www.heyvaldemar.com/install-docker-swarm-on-ubuntu-server/).

Configure Traefik and create secrets for storing the passwords on the Docker Swarm manager node before applying the configuration.

Traefik [configuration](https://github.com/heyValdemar/traefik-ssl-certificate-docker-swarm).

Create a secret for storing the password for GitLab administrator using the command:

`printf "YourPassword" | docker secret create gitlab-application-password -`

Create a secret for storing the token for GitLab Runner using the command:

`printf "YourToken" | docker secret create gitlab-runnner-token -`

Clear passwords from bash history using the command:

`history -c && history -w`

Create a secret for storing the GitLab configuration using the command:

`docker secret create gitlab.rb /path/to/gitlab.rb`

Run `gitlab-restore-application-data.sh` on the Docker Swarm worker node where the container for backups is running to restore application data if needed.

Run `docker stack ps gitlab | grep gitlab_backup | awk 'NR > 0 {print $4}'` on the Docker Swarm manager node to find on which node container for backups is running.

Deploy GitLab in a Docker Swarm using the command:

`docker stack deploy -c gitlab-traefik-ssl-certificate-docker-swarm.yml gitlab`

Register the GitLab Runner on the Docker Swarm worker node using the command:

```
GITLAB_RUNNER_CONTAINER_1=$(docker ps -aqf "name=gitlab-runner") \
&& docker container exec -it $GITLAB_RUNNER_CONTAINER_1 sh -c 'REGISTRATION_TOKEN="$(cat /run/secrets/gitlab-runnner-token)" \
&& gitlab-runner register \
--non-interactive \
--url "https://gitlab.heyvaldemar.net/" \
--registration-token "$REGISTRATION_TOKEN" \
--executor "docker" \
--docker-image docker:19.03 \
--description "docker-runner-1" \
--tag-list "docker" \
--run-untagged="true" \
--locked="false" \
--docker-privileged \
--docker-cert-path /etc/gitlab-runner \
--tls-ca-file "/etc/docker-runner/certs/gitlab.heyvaldemar.net.crt" \
--docker-volumes "/certs/client" \
--output-limit "50000000" \
--access-level="not_protected"'
```

Run `docker stack ps gitlab | grep gitlab_gitlab-runner | awk 'NR > 0 {print $4}'` on the Docker Swarm manager node to find on which node container for GitLab Runner is running.

Login to the Container Registry using GitLab credentials:

`docker login registry.heyvaldemar.net`

# Author

hey, I’m Vladimir Mikhalev, but my friends call me Valdemar.

🌐 My [website](https://www.heyvaldemar.com/) with detailed IT guides\
🎬 Follow me on [YouTube](https://www.youtube.com/channel/UCf85kQ0u1sYTTTyKVpxrlyQ?sub_confirmation=1)\
🐦 Follow me on [Twitter](https://twitter.com/heyValdemar)\
🎨 Follow me on [Instagram](https://www.instagram.com/heyvaldemar/)\
🎸 Follow me on [Facebook](https://www.facebook.com/heyValdemarFB/)\
🎥 Follow me on [TikTok](https://www.tiktok.com/@heyvaldemar)\
💻 Follow me on [LinkedIn](https://www.linkedin.com/in/heyvaldemar/)\
🐈 Follow me on [GitHub](https://github.com/heyvaldemar)

# Communication
👾 Chat with IT pros on [Discord](https://discord.com/invite/D7fGMYjdR9)\
🚀 Chat with IT pros on [Telegram](https://t.me/heyValdemarCOMchat)\
📧 Reach me at ask@sre.gg

# Give Thanks
💎 Support on [GitHub](https://github.com/sponsors/heyValdemar)\
🏆 Support on [Patreon](https://www.patreon.com/heyValdemar)\
🥤 Support on [BuyMeaCoffee](https://www.buymeacoffee.com/heyValdemar)\
🍪 Support on [Ko-fi](https://ko-fi.com/heyValdemar)\
💖 Support on [PayPal](https://www.paypal.com/paypalme/heyValdemarCOM)

