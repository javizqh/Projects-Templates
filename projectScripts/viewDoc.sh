#!/bin/bash

scriptsFolder=$HOME/Code/Scripts/project/projectScripts

usage(){
	echo -e 'Usage: viewDoc \nMust be used in a project' 1>&2
	exit 1
}

function viewHtml(){
  if [ ! -d doc/html ]; then
    bash $scriptsFolder/doc.sh
  fi
  # Cualquier browser
  opera doc/html/index.html
}

if [ -f "$PWD/.project" ]; then
  PRLANG=$(cat "$PWD/.project")
  case "$PRLANG" in
    "C")
      viewHtml
    ;;
    "CPP")
      viewHtml
    ;;
    *)
      echo "doc is not available for the ${PRLANG} project"
    ;;
  esac
else
  usage
fi


