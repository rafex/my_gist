#!/bin/bash
# @Author Raúl González
# Twitter @rafex

CONFIGURATION_JSON="update_alternatives_java_debian.json"
SUDO=$(jq '.sudo' $CONFIGURATION_JSON)

if [ $SUDO -eq 1 ]
  then
    echo "Sudo activate"
    SUDO="sudo"
  else
    echo "Sudo desactivate"
    SUDO=""
fi

# Example URL
# https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.6%2B10_openj9-0.36.0/ibm-semeru-open-jdk_x64_linux_17.0.6_10_openj9-0.36.0.tar.gz


install_update_alternatives() {
  name=$(echo $1 | tr -d '\"')
  path=$(echo $2 | tr -d '\"')
  priority=$(echo $3 | tr -d '\"')
  #echo $path
  $SUDO update-alternatives --install /usr/bin/$name $name $INSTALLATION_PATH/$path/bin/$name $priority
  update-alternatives --list $name
}

list_update_alternatives() {
  name=$(echo $1 | tr -d '\"')
  update-alternatives --list $name
}

config_update_alternatives() {
  name=$(echo $1 | tr -d '\"')
  $SUDO update-alternatives --config $name
}

count_bin=0
while [ $count_bin -lt 10 ]; do
  bin=$(jq .commands[$count_bin] $CONFIGURATION_JSON)
  action=$(jq '.action' $CONFIGURATION_JSON | xargs)
  #action=$(echo $action | xargs)
  #echo $action
  if [[ $bin == "null" ]]
    then
      echo "" > /dev/null
    else 
      echo "********** UPDATE-ALTERNATIVES [$bin] **********"
      case $action in
        list)
          list_update_alternatives $bin          
          ;;
        config)
          config_update_alternatives $bin
          ;;
      esac      
  fi
  count_bin=$(($count_bin + 1))
done  
    

