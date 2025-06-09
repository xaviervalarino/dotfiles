# Creating a brew specific user

Steps to use Homebrew on a multi-user account machine.

Because Homebrew is not meant to be used by multiple users, a separate user who
administers Homebrew needs to be created. Other users can then install packages
and casks by sudoing into the brew user. Some Homebrew directories need to be
changed to be global, as brew tends to write logs and cache to a user's home
directory.

## Create the Homebrew specific user

- Create user with admin priviledges
- Disable user from showing up in login
- Add alias for accessing brew as the brewer user:
  - `-i` have the user login, so that environment variables are set
  - `-H` use the brewer user's home directory
  - `-u` run the command as brewer user (instead of root)

```sh
# In other users .aliases file
alias brew="sudo -i -H -u brewer brew"
```

- Add environment variables for brewer
  - Set `cache `and `logs` to the homebrew prefix so they don't get written to
    other users home directory
  - Set `fontdir` so cask installed fonts are accessible to all users

```sh
# In brewer's .zshenv
export HOMEBREW_CACHE=/opt/homebrew/cache
export HOMEBREW_LOGS=/opt/homebrew/logs
export HOMEBREW_CASK_OPTS="--fontdir=/Library/Fonts"
```

- Allow other admin users to use the `brew` alias without having to use a
  password:

```sh
# In /private/etc/sudoers.d/brewer

# Allow admin users to access brewer user without having to use a password
%admin  ALL = (brewer) NOPASSWD: ALL

# Keep environment variables used by brew Defaults env_keep += "HOMEBREW_CACHE"
Defaults env_keep += "HOMEBREW_LOGS" Defaults env_keep += "HOMEBREW_CASK_OPTS"
```

## Installing FNM

Create environment variables in each user's `.zshenv`:

```sh
export FNM_DIR="/Library/Application Support/fnm"
export FNM_MULTISHELL_PATH="/Library/Application Support/fnm/versions"
```

Create the directory:

```sh
sudo mkdir -p /Library/Application\ Support/fnm
```

Install fnm to the location of fnm_dir outside of any individual user's `$HOME`
directory:

```sh
sudo curl -fsSL https://fnm.vercel.app/install \
| bash -s -- --install-dir "$FNM_DIR" --skip-shell
```

Allow other admins to read, write, execute, and other users to read and execute
in the FNM directory:

```sh
sudo chmod -R 775 "$FNM_DIR"
```
