# Set bash prompt
source .bash_prompt

# Use colorized ls
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi
alias ls="command ls ${colorflag}"

# Use colorized grep
alias grep="grep --color=auto"

# Update the system
alias update="sudo softwareupdate -i -a; brew update; brew upgrade --all; brew cleanup; sudo gem update --system; sudo gem update; conda update --name root --yes --all"

# Fix ValueError in Python
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Put miniconda on the path
export PATH=$HOME/miniconda3/bin:$PATH
