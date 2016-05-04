# Forespell development enviroment setup

## Instructions

### Installation

Run the following for a complete installation of a new system:

```
git clone https://github.com/forespell/dotfiles.git ~ && cd ~/dotfiles && source bootstrap.sh
```

This will run `bootstrap.sh`, which will apply the following:

1. Install Miniconda, Anaconda and Homebrew.
2. Run `brew bundle` to install all applications in `Brewfile`.
3. Configure the computer name and git, and set up your GitHub ssh key with `configure.sh`.
4. Install the Sublime Text preferences defined in `preferences/Preferences.sublime-settings`, Package Control and the packages defined in `preferences/Package Control.sublime-settings`.
5. Install `.bash_profile` and a Terminal.app theme that matches Sublime Text.
6. Improve OS X configuration for a development environment.

### Update

Simply run `update` from the command line to update OS X, brew and its kegs (i.e., installed apps), rubygems and its gems, conda and its packages.
