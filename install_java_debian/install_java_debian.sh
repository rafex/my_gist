#!/bin/bash

CONFIGURATION_JSON="install_java_debian.json"
TMP_PATH="/tmp/java"
INSTALLATION_PATH=$(jq '.installationPath' $CONFIGURATION_JSON)
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


download() {
  resources=$(echo $1 | tr -d '\"')
  if [ ! -d "$TMP_PATH" ]; then
    echo "$TMP_PATH does not exist."
    mkdir -p $TMP_PATH
  fi
  #wget -P $TMP_PATH -c $resources
}

unpackage() {
  folder="$INSTALLATION_PATH/$1"
  folder=$(echo $folder | tr -d '\"')
  if [ ! -d "$folder" ]; then
    echo "$folder does not exist."
    $SUDO mkdir -p $folder
  fi
  binary=$2
  binary=$(echo $binary | tr -d '\"')
  $SUDO tar -xvf "$TMP_PATH/$binary" -C $folder --strip-components=1
}

install_update_alternatives() {
  $SUDO update-alternatives --install /usr/bin/$1 $1 ${BASE_PATH}/${VERSION_NODEJS}/bin/node 10
}

COUNT=0 
while [ $COUNT -lt 100 ]; do
  control=$(jq .vendors[$COUNT].vendor $CONFIGURATION_JSON)
  #control=$(echo $control | tr -d '\"')
  #control=$(echo $control | sed 's/""//')
  if [ $control == "null" ]
    then
      echo "No more vendors"
      exit 0
  fi
  echo "Vendor of count is: $COUNT - [$(jq .vendors[$COUNT].vendor $CONFIGURATION_JSON)] - version [$(jq .vendors[$COUNT].version $CONFIGURATION_JSON)] - arch [$(jq .vendors[$COUNT].arch $CONFIGURATION_JSON)]"
  # jq .vendors[$COUNT] $CONFIGURATION_JSON
  url=$(jq .vendors[$COUNT].baseUrl $CONFIGURATION_JSON)
  url=$url$(jq .vendors[$COUNT].package $CONFIGURATION_JSON)
  url=$(echo $url | sed 's/""//')
  path="$(jq .vendors[$COUNT].version $CONFIGURATION_JSON)/$(jq .vendors[$COUNT].arch $CONFIGURATION_JSON)/$(jq .vendors[$COUNT].name $CONFIGURATION_JSON)"
  download $url
  unpackage $path $(jq .vendors[$COUNT].package $CONFIGURATION_JSON)
  
  COUNT=$(($COUNT + 1))
done
