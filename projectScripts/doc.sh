#!/bin/bash

usage(){
	echo -e 'Usage: doc \nMust be used in a project' 1>&2
	exit 1
}

function doxygenDoc(){
  doxygen Doxyfile
  cd doc/latex
  #cd doc/doxygen/latex
  make
  cd ..
  rm refman.pdf
  mv latex/refman.pdf refman.pdf
  rm -r latex
  cd ..
  #cd ../..
}

if [ -f "$PWD/.project" ]; then
  PRLANG=$(cat "$PWD/.project")
  case "$PRLANG" in
    "C")
      doxygenDoc
    ;;
    "CPP")
      doxygenDoc
    ;;
    *)
      echo "doc is not available for the ${PRLANG} project"
    ;;
  esac
else
  usage
fi


