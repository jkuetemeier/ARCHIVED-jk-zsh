#!/bin/zsh

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

GLOBAL=
LOCAL=
VERBOSE=
NOBACKUP=

while getopts “ghlv” OPTION
do
case $OPTION in
 g)
     GLOBAL=1
     ;;
 l)
     LOCAL=1
     ;;
 n)
     NOBACKUP=1
     ;;
 v)
     VERBOSE=1
     ;;
esac
done

ZDOTDIR="$dir"
DEST=$HOME

if [[ -n $GLOBAL ]]; then
  DEST="/etc"
  echo "TODO: global install... not ready yet!"
  exit -1
fi

TODAY=`date +%Y%m%d`

setopt EXTENDED_GLOB
for rcfile in "$ZDOTDIR"/runcoms/^README.md(.N); do
  DESTFILE=
  if [[ -n $GLOBAL ]]; then
    DESTFILE="$DEST/${rcfile:t}"
  else
    DESTFILE="$DEST/.${rcfile:t}"
  fi
  if [[ -z $NOBACKUP ]]; then
    MVARG=
    if [[ -n $VERBOSE ]]; then
      MVARG=-v
      [ -e $DESTFILE ] && echo "backing up $DESTFILE"
    fi

    [ -e $DESTFILE ] && mv $MVARG $DESTFILE $DESTFILE.$TODAY
  fi
  ln -s "$rcfile" $DESTFILE
#  echo ${rcfile:t}
#  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
