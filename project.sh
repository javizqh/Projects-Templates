#!/bin/bash

helpFile=$HOME/Code/Scripts/project/project.help
templatesDir=$HOME/Code/Scripts/project/templates/
userName='Javier'
userSurname1='Izquierdo'
userSurname2='Hernández'

usage(){
	echo -e 'Usage: project ....\nTo display the help menu use: project --help' 1>&2
	exit 1
}

#---------------------------FUNCTIONS-------------------------------

function checkIfAlreadyProject(){
  PROJDIR=$PWD

  while [ $PWD != $HOME -a $PWD != / ]; do
    if [ -f $PWD/.project ]; then
      cd $PROJDIR
    	echo -e 'Cannot initialize a project inside another' 1>&2
      exit 1
    fi
    cd ..
  done
  
  cd $PROJDIR
}

function setTemplate(){
  # Copy language template directory to project
  cp -r $templatesDir/$1/* $PWD

  # Set the installation scripts
  if [ "$1" = 'LATEX' ]; then
    sed -i 's/REPLACE_WITH_NEW_NAME/'$projectName'/g' preset.tex
    sed -i 's/REPLACE_WITH_USER_NAME/'$userName'/g' preset.tex
    sed -i 's/REPLACE_WITH_USER_SURNAME1/'$userSurname1'/g' preset.tex
    sed -i 's/REPLACE_WITH_USER_SURNAME2/'$userSurname2'/g' preset.tex
    mv preset.tex $projectName.tex
  else
    sed -i 's/REPLACE_WITH_NEW_NAME/'$projectName'/' install
    sed -i 's/REPLACE_WITH_NEW_NAME/'$projectName'/' uninstall
    sed -i 's/REPLACE_WITH_NEW_NAME/'$projectName'/' Doxyfile

    # Give permissions to execute
    chmod +x install

    # Move all the existing pdf to doc
    mv *.pdf doc/

  fi

  # Set the project file
  echo $1 > .project
}

function gitCreate(){
  if [ -d ".git" ]; then
    echo "Already exists"
  else
    git init
  fi
  mv .git/hooks/pre-commit .git/hooks/pre-commit.old 2> /dev/null
  cp $templatesDir/pre-commit .git/hooks/pre-commit
  cp $templatesDir/gitignore .gitignore
}

function askProjectName(){
  echo -n "Input project name: "
  read name
  if [ -z "$name" ]; then
    askProjectName
  fi

  # Set the project name
  projectName=$name
}

function askLanguage(){
  echo -n "Input project language: "
  read language
  case "${language}" in
    "cpp"|"c++")
      langConfig="CPP"
    ;;
    "python")
      langConfig="PYTHON"
    ;;
    "bash"|"shell")
      langConfig="BASH"
    ;;
    "tex"|"latex")
      langConfig="LATEX"
    ;;
    *)
      echo "Select a valid language"
      askLanguage
    ;;
  esac
}

function askCreateGit(){
  echo -n "Do you want to create use git repositories [Type Y/n]: "
  read gitConfig
  case "${gitConfig}" in
  "Y")
    gitConfig=1
  ;;
  "n")
    gitConfig=0
  ;;
  *)
    askCreateGit
  ;;
  esac
}

function openWithTexStudio(){
  echo -n "Do you want to open this project in TexStudio [Type Y/n]: "
  read openConfig
  case "${openConfig}" in
  "Y")
    editorConfig="tex"
  ;;
  "n")
    editorConfig=0
  ;;
  *)
    openWithTexStudio
  ;;
  esac
}

function openWithVScode(){
  echo -n "Do you want to open this project in Vs Code [Type Y/n]: "
  read openConfig
  case "${openConfig}" in
  "Y")
    editorConfig="vs"
  ;;
  "n")
    editorConfig=0
  ;;
  *)
    openWithVScode
  ;;
  esac
}

function openWithTerminator(){
  echo -n "Do you want to open this project in Terminator [Type Y/n]: "
  read openConfig
  case "${openConfig}" in
  "Y")
    editorConfig="tr"
  ;;
  "n")
    editorConfig=0
  ;;
  *)
    openWithTerminator
  ;;
  esac
}

function createProject(){
  echo -e "\nCreating new $1 project"

  # Create git repositorie
  case "$2" in
    1)
      gitCreate
    ;;
    0)
    ;;
    *)
      exit 1
    ;;
  esac

  # Create language project
  setTemplate $1

  # Open project in VS Code
  case "$3" in
    "vs")
      code .
    ;;
    "tr")
      terminator -l "Coding" -p "Cpp"
    ;;
    "tex")
      texstudio $projectName.tex
    ;;
    0)
    ;;
    *)
      exit 1
    ;;
  esac
}
#-----------------------END OF FUNCTIONS----------------------------

#---------------------------MAIN------------------------------------
checkIfAlreadyProject

echo "Create a new project"

langConfig='none'
askLanguage

projectName='default'
askProjectName

gitConfig=0
askCreateGit

echo $langConfig
editorConfig=0
if [ "$langConfig" = 'LATEX' ];then
  openWithTexStudio
else
  openWithVScode
  if [ "$editorConfig" = "0" ]; then
    openWithTerminator
  fi
fi

createProject "$langConfig" "$gitConfig" "$editorConfig"
exit 0
#-----------------------END OF MAIN---------------------------------