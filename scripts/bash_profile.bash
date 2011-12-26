# history handling
#
# Erase duplicates
export HISTCONTROL=erasedups
# resize history size
export HISTSIZE=5000
# append to bash_history if Terminal.app quits
shopt -s histappend

export VISUAL=less
export EDITOR=emacs
export GIT_EDITOR=emacs


# Cli Colors
export CLICOLOR=1
# use yellow for dir’s
export LSCOLORS=dxfxcxdxbxegedabagacad

export PATH=/opt/local/bin:/opt/local/sbin:~/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

export RUBYMINE_HOME="/Applications/RubyMine 3.2.4.app/"

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ "`/usr/bin/whoami`" == "root" ]; then
    export PS1="[\h:\w]: \u# "
else
    export PS1="[\h:\w]: \u$ "
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"