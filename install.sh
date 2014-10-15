#!/usr/bin/env sh

USERSHELL=`grep "^$LOGNAME" /etc/passwd | cut -d ':' -f 7`
DEFAULTSHELL=${SHELL:-$USERSHELL}
DEFAULTSHELL=${DEFAULTSHELL:-`which zsh`}
DEFAULTSHELL=${DEFAULTSHELL:-$0}

echo "Detected User: $LOGNAME"

ZSH=`which zsh`
if [[ ! $ZSH =~ 'zsh' ]]; then 
  echo "no zsh found, perhaps you should try to install it."
  exit -1
fi

echo "User default shell: $DEFAULTSHELL"

if [[ $DEFAULTSHELL =~ 'zsh' ]]; then 
  echo "zsh ist already the default user shell -> Good!"
else 
  echo "changing default user shell to zsh... (chsh -s $ZSH)"
  chsh -s $ZSH
fi

