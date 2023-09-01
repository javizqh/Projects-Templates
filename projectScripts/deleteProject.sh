#!/bin/bash

usage(){
	echo -e 'Usage: deleteProject \nMust be used in a project' 1>&2
	exit 1
}



if [ -f "$PWD/.project" ]; then
  echo -n "Do you want to delete this project [Type Y/n]: "
  read canDelete
  case "${canDelete}" in
  "Y")
    rm -r "$PWD"
  ;;
  "n")
    exit 0
  ;;
  *)
    exit 0
  ;;
  esac
else
  usage
fi