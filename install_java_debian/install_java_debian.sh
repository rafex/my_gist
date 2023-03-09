#!/bin/bash
# @Author Raúl González
# Twitter @rafex

CONFIGURATION_JSON="install_java_debian.json"
TMP_PATH="/tmp/java"
INSTALLATION_PATH=$(jq '.installationPath' $CONFIGURATION_JSON)
INSTALLATION_PATH=$(echo $INSTALLATION_PATH | tr -d '\"')
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
  wget -P $TMP_PATH -c $resources
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
  name=$(echo $1 | tr -d '\"')
  path=$(echo $2 | tr -d '\"')
  priority=$(echo $3 | tr -d '\"')
  #echo $path
  $SUDO update-alternatives --install /usr/bin/$name $name $INSTALLATION_PATH/$path/bin/$name $priority
}

count=0 
while [ $count -lt 100 ]; do
  vendor=$(jq .vendors[$count].vendor $CONFIGURATION_JSON)
  if [ $vendor == "null" ]
    then
      echo "No more vendors"
      exit 0
  fi

  ignore=$(jq .vendors[$count].ignore $CONFIGURATION_JSON)

  if [ $ignore -eq 0 ]; then
    echo "Vendor of count is: $count - [$vendor] - version [$(jq .vendors[$count].version $CONFIGURATION_JSON)] - arch [$(jq .vendors[$count].arch $CONFIGURATION_JSON)]"
    # jq .vendors[$count] $CONFIGURATION_JSON
    url=$(jq .vendors[$count].url $CONFIGURATION_JSON)
    url=$(echo $url | sed 's/""//')
    priority=$(jq .vendors[$count].priority $CONFIGURATION_JSON)
    name=$(jq .vendors[$count].package $CONFIGURATION_JSON)
    name=$(echo "${name%.*.*}")
    path="$(jq .vendors[$count].version $CONFIGURATION_JSON)/$(jq .vendors[$count].arch $CONFIGURATION_JSON)/$name"
    package=$(jq .vendors[$count].package $CONFIGURATION_JSON)

    download $url
    unpackage $path $package

    count_bin=0
    while [ $count_bin -lt 10 ]; do
      bin=$(jq .vendors[$count].binarys[$count_bin] $CONFIGURATION_JSON)
      if [ $bin == "null" ]
        then
          echo ""
        else 
          install_update_alternatives $bin $path $priority
      fi
      count_bin=$(($count_bin + 1))
    done  
        
  fi
  
  count=$(($count + 1))
done

update-alternatives --list java
