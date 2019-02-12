# dotfiles
Personal Bash/Zsh configuration and startup scripts

![screenshot of dotfiles default theme](https://i.imgur.com/p9fKz7s.png)

## Requirements

- macOS/OS X, Debian/Ubuntu, or Red Hat/CentOS
- Bash 4.0+ or Zsh 5.0+

These dotfiles may work in other environments without modification, but that
hasn't been tested.

**Note for Mac users:** Mac ships with Bash v3.2.57 from 2007, so
[brew install](http://brew.sh) an updated Bash first.

## Installation

Run these two commands, and that's it:

```bash
git clone https://github.com/oqkr/dotfiles ~/.config/dotfiles
~/.config/dotfiles/install
```

The installer script does the following:

- backs up these files and directories if they exist:
  - `~/.bash_profile`
  - `~/.bashrc`
  - `~/.zshrc`
  - `~/.bash_logout`
  - `~/.zlogout`
  - `~/.vimrc`
  - `~/.vim_runtime/`
  - `~/.config/dotfiles/`
- symlinks [startup.sh](startup.sh) as these files:
  - `~/.bash_profile`
  - `~/.bashrc`
  - `~/.zshrc`
- symlinks [logout.sh](logout.sh) as these files:
  - `~/.bash_logout`
  - `~/.zlogout`
- creates `<dotfiles_home>/local.d` for machine-local configuration
- installs [Awesome Vimrc](https://github.com/amix/vimrc.git)

## How It Works

New Bash or Zsh shells source [startup.sh](startup.sh) first thing.

If the shell is interactive, startup checks if we're using Zsh and, if there is
an [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) (OMZ) installation,
adds OMZ settings and runs OMZ's
[startup script](https://github.com/robbyrussell/oh-my-zsh/blob/master/oh-my-zsh.sh).

Next, startup sources [dotfiles.sh](lib/dotfiles.sh),
running its [init function](lib/dotfiles.sh#L45) to apply general Bash/Zsh
settings then sourcing each startup script in
[profile.d/](profile.d) in lexical order.

Finally, startup sources every file in `~/.config/dotfiles/local.d` in lexical
order.

For more details, check README files in other directories and code comments.

## Customization

The best way to add configuration or functions to these dotfiles is to create a
new startup script in [profile.d/](profile.d) and place your additions there.

(Adding to `~/.bashrc` or `~/.zshrc` is possible but discouraged; there is a
defensive `return` at the bottom of the file to prevent it: Poorly behaved
programs frequently add to those files with or without permision, making it
difficult to know what is happening, when it happens, and in what order.)

If you need a file in `profile.d/` to load before another file, you can use the
[dotfiles::load_before()](lib/dotfiles.sh#L239) function to set a depends-on
relationships between startup scripts.

Installation creates a `~/.config/dotfiles/local.d` directory with these
files:

- `local.sh`, where you can place machine-local configuration
- `secret.sh`, where you can save private data such as environment variables
containing API tokens.

The entire `local.d` directory is [ignored by Git](.gitignore) by default.

## TODO

- [ ] Add READMEs for other directories
- [ ] Add instructions/command for upgrading
- [ ] Create `bin/dotfiles` utility for installation, redoing symlinks, etc.
- [ ] Add config files for common utilities to move into `~/.config` on
installation, such as `~/.config/git`.