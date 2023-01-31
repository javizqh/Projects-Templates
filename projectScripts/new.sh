#!/bin/bash

usage(){
	echo -e 'Usage: new <fileName> \nMust be used in a project' 1>&2
	exit 1
}


if [ -f $PWD/.project ]; then
  PRLANG=$(cat $PWD/.project)
  case "$PRLANG" in
    "cpp")
      touch src/$1.cpp
      touch include/$1.h
    ;;
    *)
      echo "doc is not available for the ${PRLANG} project"
    ;;
  esac
else
  usage
fi
