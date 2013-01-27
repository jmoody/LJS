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


export GROWLNOTIFY="/usr/local/bin/growlnotify"

export DEVELOPER_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin
export PATH=$DEVELOPER_PATH:/opt/local/bin:/opt/local/sbin:~/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH


export RUBYMINE_HOME="/Applications/RubyMine.app/"

if [ -d /usr/local/etc/bash_completion.d ]; then
    . /usr/local/etc/bash_completion.d/git-completion.bash
    . /usr/local/etc/bash_completion.d/git-prompt.sh
fi


if [ "`/usr/bin/whoami`" == "root" ]; then
    export PS1="[\h:\w]: \u# "
else
    export PS1="[\h:\w]: \u$ "
fi

alias be='bundle exec'
alias btar='tar --use-compress-program /opt/local/bin/bzip2 '
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin 





##
# Your previous /Users/moody/.bash_profile file was backed up as /Users/moody/.bash_profile.macports-saved_2013-01-08_at_16:31:19
##

# MacPorts Installer addition on 2013-01-08_at_16:31:19: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

