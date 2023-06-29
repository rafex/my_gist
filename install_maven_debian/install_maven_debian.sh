#!/bin/bash
# @Author Raúl González
# Twitter @rafex

CONFIGURATION_JSON="install_maven_debian.json"
TMP_PATH="/tmp/maven"
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

  echo "------------------------------------------"
  echo $folder
  echo "------------------------------------------"

  if [ ! -d "$folder" ]; then
    echo "$folder does not exist."
    $SUDO mkdir -p $folder
  fi
  binary=$2
  binary=$(echo $binary | tr -d '\"')
  $SUDO tar -xf "$TMP_PATH/$binary" -C $folder --strip-components=1
}

install_update_alternatives() {
  name=$(echo $1 | tr -d '\"')
  path=$(echo $2 | tr -d '\"')
  priority=$(echo $3 | tr -d '\"')
  #echo $path
  $SUDO update-alternatives --install /usr/bin/$name $name $INSTALLATION_PATH/$path/bin/$name $priority
  update-alternatives --list $name
}

count=0 
while [ $count -lt 100 ]; do
  version=$(jq .versions[$count].version $CONFIGURATION_JSON)
  #version=$(echo $version | tr -d '\"')
  #echo "------------------------------------------"
  #echo $version
  #echo "------------------------------------------"
  if [ $version == "null" ]
    then
      echo "No more versions"
      
      exit 0
  fi

  ignore=$(jq .versions[$count].ignore $CONFIGURATION_JSON)
  install=$(jq .install $CONFIGURATION_JSON)

  if [ $ignore -eq 0 ]; then
    if [[ $install == $version ]] || [ $install == "all" ]; then
      echo "Version of count is: $count - version [$(jq .versions[$count].version $CONFIGURATION_JSON)]"
      url=$(jq .urlBin $CONFIGURATION_JSON)
      url=$(echo $url | sed -e "s/VERSION/${version}/g")
      url=$(echo $url | sed 's/""//')
      priority=$(jq .versions[$count].priority $CONFIGURATION_JSON)
      name=$(jq .versions[$count].package $CONFIGURATION_JSON)
      name=$(echo $name | sed -e "s/VERSION/${version}/g")
      name=$(echo "${name%.*.*}")
      path="$(jq .versions[$count].version $CONFIGURATION_JSON)/$name"
      package=$(jq .versions[$count].package $CONFIGURATION_JSON)
      echo $package
      package=$(echo $package | sed -e "s/VERSION/${version}/g")
      echo $package
      download "$url/$package"
      unpackage $path $package      

      count_bin=0
      while [ $count_bin -lt 10 ]; do
        bin=$(jq .versions[$count].binarys[$count_bin] $CONFIGURATION_JSON)
        if [[ $bin == "null" ]]
          then
            echo "" > /dev/null
          else 
            echo "UPDATE-ALTERNATIVES [$bin $path $priority]"
            install_update_alternatives $bin $path $priority            
        fi
        count_bin=$(($count_bin + 1))
      done  
    fi
        
  fi
  
  count=$(($count + 1))
done


