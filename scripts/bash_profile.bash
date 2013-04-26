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
export GIT_EDITOR="${EDITOR}"

# Cli Colors
export CLICOLOR=1
# use yellow for dir’s
export LSCOLORS=dxfxcxdxbxegedabagacad

export PYTHONPATH=".:/opt/local/lib/python2.7/site-packages"
export PLISTBUDDY_PATH="/usr/libexec/PlistBuddy"
export GROWLNOTIFY="/usr/local/bin/growlnotify"
export GROWLNOTIFY_PATH="/usr/local/bin/growlnotify"
export LJS_MACOS_SIGNING_IDENTITY="Developer ID Application: Joshua Moody"
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
export DEVELOPER_PATH="/Applications/Xcode.app/Contents/Developer/usr/bin"
export XCODEBUILD_452_PATH="/Xcode/4.5.2/Xcode.app/Contents/Developer/usr/bin/xcodebuild"
export SECURITY_PATH=`which security`
export CODESIGN_PATH=`which codesign`
export SPCTL_PATH=`which spctl`
export ZIP_PATH=`which zip`

export PATH=$DEVELOPER_PATH:~/bin::$PATH
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

alias bui='bundle update && bundle install'
alias be='bundle exec'
alias btar='tar --use-compress-program /opt/local/bin/bzip2 '
alias rt='./run-tests.sh'

# MacPorts Installer addition on 2013-01-08_at_16:31:19: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Postgres ###
PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"

### HOME BREW ###
export PATH=/usr/local/bin:$PATH

### RUBY ENV ###
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

eval "$(rbenv init -)"
