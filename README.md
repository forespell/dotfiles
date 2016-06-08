## Forespell development enviroment setup

### Installation

Run the following for a complete installation of a new system:

```
git clone https://github.com/forespell/dotfiles.git ~ && cd ~/dotfiles && source bootstrap.sh
```

This will run `bootstrap.sh`, which will apply the following:

1. Copy `preferences/.bash_profile` to your home folder, unless it already exists.
2. Configure the computer name and git, and set up your GitHub ssh key with `configure.sh`.
3. Install Miniconda, Anaconda and Homebrew.
4. Run `brew bundle` to install all applications in `Brewfile`.
5. Install the Sublime Text preferences defined in `preferences/Preferences.sublime-settings`, Package Control and the packages defined in `preferences/Package Control.sublime-settings`.
6. Install a Terminal.app theme that matches Sublime Text.
7. Improve OS X configuration for a development environment.

### Update

Simply run `update` from the command line to update OS X, brew and its kegs (i.e., installed apps), rubygems and its gems, conda and its packages.
