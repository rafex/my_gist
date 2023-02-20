#!/bin/bash

# run script with root

PATH_NODE_MODEULES="/opt/nodejs/19.6.0/lib/node_modules"

npm install --global yarn

update-alternatives --install /usr/bin/yarn yarn ${PATH_NODE_MODEULES}/yarn/bin/yarn 10
