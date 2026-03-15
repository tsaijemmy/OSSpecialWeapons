#!/bin/bash
# WF 2018-07-12
# find out the class versions with in jar file
# see https://stackoverflow.com/questions/3313532/what-version-of-javac-built-my-jar

# uncomment do debug
# set -x

#ansi colors
#http://www.csc.uvic.ca/~sae/seng265/fall04/tips/s265s047-tips/bash-using-colors.html
blue='\033[0;34m'  
red='\033[0;31m'  
green='\033[0;32m' # '\e[1;32m' is too bright for white bg.
endColor='\033[0m'

#
# a colored message 
#   params:
#     1: l_color - the color of the message
#     2: l_msg - the message to display
#
color_msg() {
  local l_color="$1"
  local l_msg="$2"
  echo -e "${l_color}$l_msg${endColor}"
}

#
# error
#
#   show an error message and exit
#
#   params:
#     1: l_msg - the message to display
error() {
  local l_msg="$1"
  # use ansi red for error
  color_msg $red "Error: $l_msg" 1>&2
  exit 1
}

#
# show the usage
#
usage() {
  echo "usage: $0 jarfile"
  # -h|--help|usage|show this usage
  echo " -h|--help: show this usage"
  exit 1 
}

#
# showclassversions
#
showclassversions() {
  local l_jar="$1"
  jar -tf "$l_jar" | grep '.class' | while read classname
  do
    class=$(echo $classname | sed -e 's/\.class$//')
    class_version=$(javap -classpath "$l_jar" -verbose $class | grep 'major version' | cut -f2 -d ":" | cut -c2-)
    class_pretty=$(echo $class | sed -e 's#/#.#g')
    case $class_version in
      45.3) java_version="java 1.1";;
      46) java_version="java 1.2";;
      47) java_version="java 1.3";;
      48) java_version="java 1.4";;
      49) java_version="java5";;
      50) java_version="java6";;
      51) java_version="java7";;
      52) java_version="java8";;
      53) java_version="java9";;
      54) java_version="java10";;
      55) java_version="java11";;
      56) java_version="java12";;
      57) java_version="java13";;
      58) java_version="java14";;
      59) java_version="java15";;
      60) java_version="java16";;
      61) java_version="java17";;
      62) java_version="java18";;
      63) java_version="java19";;
      64) java_version="java20";;
      65) java_version="java21";;
      66) java_version="java22";;
      67) java_version="java23";;
      68) java_version="java24";;
      69) java_version="java25";;
      70) java_version="java26";;
      *) java_version="x${class_version}x";;
    esac
    echo $java_version $class_pretty
  done
}

# check the number of parameters
if [ $# -lt 1 ]
then
  usage
fi

# start of script
# check arguments
while test $# -gt 0
do
  case $1 in
    # -h|--help|usage|show this usage
    -h|--help) 
      usage
      exit 1
      ;;
    *)
     showclassversions "$1"
  esac
  shift
done
