#!/usr/bin/env sh

# chdir to script dir
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

usage()
{
cat << EOF
usage: $0 options

This script can be installed local ($HOME) or global.

OPTIONS:
   -h      Show this message
   -l      install local ($HOME/.jk-sys)
   -g      install global (/opt/jk-sys)
   -v      Verbose

EOF
}

GLOBAL=
LOCAL=
VERBOSE=

while getopts “ghlv” OPTION
do
case $OPTION in
 g)
     GLOBAL=1
     ;;
 h)
     usage
     exit 1
     ;;
 l)
     LOCAL=1
     ;;
 v)
     VERBOSE=1
     ;;
 ?)
     usage
     exit
     ;;
esac
done

if [[ -z $GLOBAL ]] && [[ -z $LOCAL ]]; then
  usage
  exit 1
fi

if [[ -n $GLOBAL ]] && [[ -n $LOCAL ]]; then
  echo "ERROR: You can install only global OR local"
  usage
  exit 1
fi

if [[ -n $VERBOSE ]]; then
  if [[ -n $GLOBAL ]]; then
    echo "zsh - starting global install..."
  else 
    echo "zsh - starting local install..."
  fi
fi


USERSHELL=`grep "^$LOGNAME" /etc/passwd | cut -d ':' -f 7`
DEFAULTSHELL=${SHELL:-$USERSHELL}
DEFAULTSHELL=${DEFAULTSHELL:-`which zsh`}
DEFAULTSHELL=${DEFAULTSHELL:-$0}

if [[ -n $VERBOSE ]]; then
  echo "Detected User: $LOGNAME"
fi

ZSH=`which zsh`
if [[ ! $ZSH =~ 'zsh' ]]; then 
  echo "no zsh found, perhaps you should try to install it."
  exit -1
fi

if [[ -n $VERBOSE ]]; then
  echo "User default shell: $DEFAULTSHELL"
fi

if [[ $DEFAULTSHELL =~ 'zsh' ]]; then 
  echo "zsh ist already the default user shell -> Good!"
else 
  echo "changing default user shell to zsh... (chsh -s $ZSH)"
  chsh -s $ZSH
fi

$ZSH backup-and-create-links.zsh "$@"
