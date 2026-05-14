# Setup

0. Ensure URLs are added to SSH keys in 1password

   ```personal github
   ssh://git@github.com
   ```

   ```work github
   ssh://ghwork
   ```

1. Ensure SSH config is symlinked to ~/.ssh/config
2. Copy ssh config_override to ~/.ssh/config_override
3. Enable 1Password SSH Agent
4. Enable "Generate SSH config file with bookmarked hosts"
5. Uncomment 1Password config include in ~/.ssh
6. Add ssh config override hosts to match 1Password SSH url

```~/.ssh/config_override
Include ~/.ssh/1Password/config

Host github
  HostName github.com
  User git

Host ghwork
  HostName github.com
  User git
```
