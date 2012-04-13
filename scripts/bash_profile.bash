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

export POSTGRES_PATH=/Library/PostgreSQL/9.0/bin
export DEVELOPER_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin
export PATH=/opt/local/bin:/opt/local/sbin:$DEVELOPER_PATH:$POSTGRES_PATH:~/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

export RUBYMINE_HOME="/Applications/RubyMine 3.2.4.app/"

export CLASSPATH=~/lib/quaqua:$CLASSPATH

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ "`/usr/bin/whoami`" == "root" ]; then
    export PS1="[\h:\w]: \u# "
else
    export PS1="[\h:\w]: \u$ "
fi

alias be='bundle exec'
alias cuke='NO_LAUNCH=1 OS=ios5 cucumber'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
